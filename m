Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019EB606A6BF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1FYfrGT
Received: by kanga.kvack.org (Postfix)
	id CE7296B00EF; Fri, 20 Nov 2026 20:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98EE6B05B0; Fri, 20 Nov 2026 20:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BD16B05B1; Fri, 20 Nov 2026 20:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86E3A6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:32:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00F0DA02B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:32:10 +0000 (UTC)
X-FDA: 85457400420.10.7A079C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 61A98C0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:32:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1FYfrGT;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795224729;
	b=eFYx6xngx/0jK+1KWKqUTBbnXZKbMHD6quEEenkBlgucg1EknZRm3bCSNWY+5HEDgp+TzU
	6WVk0khPIVtPKkgib0ucCb09Hu0UdRvQDBaY+Gc/77Yvm97VLNyLd41fzvJwDExeSBXOKI
	wbVY14YXy3ovq/evg80nnSfBgbcbPLQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795224729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/7MyMIXr0GDno34tV42HvOi56g013l0wGScJy1uGp0=;
	b=4vr88j8xfX+1bTSNs2JT3NeQFTmtN3+GG2MSbXX+iMWZ7NLwBlpX5RX3r6r+/uvym0a5Ln
	MuPzfaYOTZFxAKqtdSxaPsMMiSsymgUtsZn9WRR48tiVU9xdotKOUKYRniuDwN+sdOIDNS
	EqqRQ1SdEftJf1KOc/Y5Qo9AI6d4mZo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1FYfrGT;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 78598618F0;
	Sat, 21 Nov 2026 01:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8B58A1F000D2;
	Sat, 21 Nov 2026 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795224728;
	bh=5/7MyMIXr0GDno34tV42HvOi56g013l0wGScJy1uGp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V1FYfrGTatK4t00vmPWVjtv5HLsnbLBQJryhm1RAw1jnSsFpourNb3t1IjzSNXxX9
	 6Bq0R9I4WaCdpXZX3hs2TSXWe+ogMvOxCYptsDe9heLB/DRu3jnf1Ra6f6JDEemD1j
	 7Ztegvu2jmd0It2EtCck+YGJjbblBujYOojylXdkcLxQW+4YV4lXpMp4fzKNiIc96d
	 zWTi4ICSpKYW7JvYV71KxHiIMYRy0vFhI0sCj4pcDHT8NJHbwAYCAZIa4sbRh/LMYQ
	 Q2vVzh7EY9qiZrVGlr9vAi90q99Jbd7CoOV5MuyrCPk6oRrhEKBAi7Y4to5qFVrlj3
	 tsOSq4fsG9ZWw==
Date: Sat, 21 Nov 2026 03:32:04 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 12/25] rootns: Track init lifecycle via
 copy_process() and pid_namespace
Message-ID: <awD0lNmhRPaXI9Pg@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-13-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-13-jarkko@kernel.org>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 61A98C0003
X-Stat-Signature: icjwu97gpdz6isybymmmn3am47czszy6
X-Rspam-User:
X-HE-Tag: 1795224729-561896
X-HE-Meta: U2FsdGVkX1+dAAeFAmmO5P+9k8/wef5Xjh4Huac5FENXNHaSoxGfyNL43T36s//grUUMX575wCJVZW8JhpHuH46FtaVbcrSNWjBAMRM5fhnukvoziJDQD817XfwoePA0btesXdpf7JrHeryGYV7zigt3s4J+VZVfE+OTLV4NnOs4JYRbVt0LP5TuRZOVOq5cUjszHxlZIjMLxbtjrWBFoVLU/P+pL2imfLc43Xi4ZukBA1hFRtgE2pUvRiVH38C7dxiwJq9VoCKeknPWbuirsVgEhP3E+Pp2J01mdOhalSDNjaLnux1L9qURQvQLZKvb8DrR4Omo20vMNNT9r/mW5rC3e9YaSFBwRcjyWv4djKEkxnzySz/Povq7RLOm70aYR9z49pi7LO5Zp5JptmhApjn+SFxfKikc7hbPZ0rgRDPBghXjAB6ugdJjEyfGqabM7mlsFvjStDpuqXLGRnMNKssi1g0W9CU0HvRhyFfUrge/zP54CGK18TxD+8nY3xsx0AaZeOEzJQSTaa4v6EHskZz9rBZ9QMD3EGyBo/pnsIAkNuKaamZo5tZcwmgJ4FhRSeAAceV0FoqqaK8HZ2bQfco6vC3rnQppHZ3uOJwdOz1BljD/6/R2W0TAqtebbF640AIbqNelTQGbG67/HqPAio7yZTOjcuhwHV44qHWiiZemf64/e+YJF0zyjAB3l/hy7ViHahIWuGVwm9owbBgRWOGPwiwVOpl/fsM/1jysrJjm/oPBpAeMQUA133oYLMxfbFt1DC1kvr+otTdDlX1mTwQrRBqHzWbc6jnyHjhBIbxVFQAxaTVtzvO3eyeOiq4lFUjTO0kocMBOI498iqIoiNVQFkW47pxFPV9gKXERjt5kSiVH2S3YwLhqgaGapT350Fhjyi5TSMh7KZW8XDP+LQ1QkctDLSip58qR+wJjpoY2GAEZbl31BQxxXBme8Yv0Z6o4Lx9XNAETMwqAMv8
 BtzZ+lxU
 jtpZEPTNl6hBZc8Igz1hIYEu+gz4ial13rS2tY/hxBZ0jG50L1SMo64l8IcPqfSWsQvCCxtp0RESgj0xKvumnTiYnI0gza/Fahupz3qyP46cJ+FwfloS6BCYn5nlbXpaCpmFTQp2Pnh7wQqIKYdkZ6Hoz39c/PznrUPGybnTUgos8NN36tlkd/A6q2rlk8aN4mWwxrH41j/ayhT/oITn3E1Hi9ZaHcE1tOiFBKa8rK4PsR2kxJd/r46gMRLPP7HAcGMuRlHlvN0DAVHWMz3h8KHNhGiz3OdcGJwUCm9DETTkdkbfHGImfqUtNzKEO9eIO1wQzk7OYUaJb7/96UQN3ci7rDkTOuOFPzjTOq+9oIKbyuFiI9wnWd8Sj2IGgbYNm5DqFSbe/VA3+kcch54E1SovHpiac3Ax/cN61Z9nMCRKEOxOMJPaY455y9YqUFZqFNz+g4zYPEE5hD6hv76zd8hbxbURolKwsHoPm0hkvkJ/yMvJO0ghjsNCxSh2uyhl32Sy+brMUXdQ0KDGphlVovgxo1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:31AM +0200, Jarkko Sakkinen wrote:
> A root namespace needs to record its init thread group's PID when
> bootstrapped and capture its exit status once all processes in the root
> namespace have terminated, without serializing normal fork() and exit()
> paths inside the container.
> 
> Commit the bootstrap child reaper and bind pid_ns->rootns in
> copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
> from zap_pid_ns_processes() after the root namespace's PID namespace has
> killed and reaped all member tasks.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

ROOTNS_GET_NSFD will be the only surviving ioctl, which make access
control wise sense.

This leaves room for ROOTNS_SHARE_NSFD, which would share a namespace
from host. This makes whole a lot more sense than unsharing security
wise as it is allow listing (instead of deny listing).

It can be post-clone3 disabled. This is what we do in SGX driver i.e.,
have build phase enabled ioctls.

Br, Jarkko

