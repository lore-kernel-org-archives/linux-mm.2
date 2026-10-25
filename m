Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A65606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GjcPZQK5
Received: by kanga.kvack.org (Postfix)
	id 43B056B05B2; Sun, 25 Oct 2026 10:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBE96B05B3; Sun, 25 Oct 2026 10:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302996B05B4; Sun, 25 Oct 2026 10:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F36456B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:59:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B41A412060B
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:59:43 +0000 (UTC)
X-FDA: 85361457846.28.06E740B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 037C7100003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:59:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjcPZQK5;
	spf=pass (imf14.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792940382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypAazgUbAvcxzmZkxRES4uqcUMkrnn//bRJm+xkJQNQ=;
	b=X1BzHzEE+yy5dT+dPjsLcFQZPBgTxZaaeRo6BvvtpQWMFPlJrSpcIc/YgDk5bbLvL/YYsA
	2Fjqz6cYEGNn932HO/SZQ83zIbJwNwX4KZPni76CxSg5gMs0KQEh0HQoXsGKr4IRRx5Qjx
	Gn39gYhCe9iGDCo2wNCrHXfjleL15JA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792940382;
	b=zWzxnjc2YUdYB4MkD9FwqEciUk3VGZIivPW0mQ5K4EW+UlyPkjaR9uiAhrkWdqP/IlsTUm
	xvKRofar3rgQltKWvSmUOheRowFUEnSu0kQ19c4s1AguyLlGHv7Mc/txrit9X6pUPyiOlR
	SjbEZl+If1MNBhBPCwsubjZoDFSeCM8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjcPZQK5;
	spf=pass (imf14.hostedemail.com: domain of cel@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cel@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E81C40AD9;
	Sun, 25 Oct 2026 14:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F851F01825;
	Sun, 25 Oct 2026 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792940380;
	bh=ypAazgUbAvcxzmZkxRES4uqcUMkrnn//bRJm+xkJQNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjcPZQK5iFURP6dUTzxcQVaYijWU2eWa1KT+DK3eUv/g/RyN5lMD431tjUXYA/Pih
	 ylmqKCA2WjGbgXyrlDjat63QU3ZBE+Bf1rbZhowUGRXZWhffTzFaV2Vpf/A6sRMeKY
	 ZDCXtLFsDGPFYfL+9yzKajcL8wRlQAN3TwcxAwRDy95EUgxZcWd8mIvQ6Jcqtgh7E1
	 3FOpGqXpaM6j8nruSkESHqLyv/qvEbtxMxri2V8ctfEOe0csR1+xOmE/ZbeKy1Eyi6
	 a/i5YgfoQcCA6qJ4fzZFUz8X4tJnaC2mnBAFx5d9//rR0TJEvQbXar7rzqNKFLRwoH
	 IHrUeLBVXHnHQ==
From: Chuck Lever <cel@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH cel/nfsd-testing replacement] NFSD: cut a misaligned direct-mode WRITE at folio boundaries
Date: Sun, 25 Oct 2026 10:59:36 -0400
Message-ID: <179294034533.680410.17193539426864107681.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <at0DFod8CcUfus2S@kernel.org>
References: <at0DFod8CcUfus2S@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 037C7100003
X-Stat-Signature: 9japgdhtbke4msi73dsf3991nf443qyk
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792940381-760442
X-HE-Meta: U2FsdGVkX1/j5MrkXahfC13Ge1av/olbdvcpmpW8jJ13Vgf7BuUYTv0sJGzONRAtw4NDnPP5g8oDlvUDL1QK/7RutfrGcTAt+VYrMXiGFDjdn003i5/lRkb9czHldP2y6tel2Ik3dYOvNLgaxuRx9r9isIwbfL2uQ8hNnnvXo966tEVKuIQqs7BS8vppZfUB6uO6HARMcpZppPN3eT8suk22PgL0nv49eNikGgOR+z2P9cO9iwDQqZ0/F9Tc007bjagkR8dIpEz39xMrimH/J9bmoyb0QrIJ9QJI+yIgD2WDNB7wPuiL3nGhi9taR6hXOHVF7/CRFTANMWnwhXd6npo6Gl9/aWCnTUKYipr2PCSABj+pgQTK8hd0vwT3OIp68X7MrWhJjOQA/4PfMzQK3V2kMsLKYwPctqwbV2/6iooMTpsB0TRPUul6naMUWLuW22LTsFAR7hvFiHfR7A8YnwEwoiEF0I1a4dNtX36yWpz7r3Sfpe1ThiYKlPGihrw1wv3Z5FfZNPQakpvj/sBmfYHJNkftmXq1qUuyatHfsPZ6V9LjjDrym0W0Zmo0TB821/D7qwyFda3bj0bqro7JcD6BcBXLZDR3/jz0ZhIXRMcukltsuzHfFUNCwwJEOB8hpgnvO/4dcd5BkUAjDgHl8ThKxTPUiLjo7+Z+5fLFt9GbkKpMH0Jc/DxCSjTwy/nMAqlXd3YeTZQgkRAoWqxvzH2PknQboz3LEOSNrrWDHHy3YaabopXUUseLrwgAH5fbvsaMMfIZKdQBkuW6OAfOtYR0UvWsmnuQsHFkWoLTE/gSE9cwKc5qSGmy1mHVHyf2qtoCzdGgcIJMblQbvzx8Ct7/eMjCifKT6K11DXQUrxVF+OFbzgFxUDUHY9etj+Zk9RTZ9yE3fJTFXBjvlufX/vB9es9CwfGsSy/xev5Tq17wNGQE+zZM0UbbwQv4u++hotlFTo+/V2jx5vJWIfT
 SMG3LuOe
 iTWFs74Y2KH/VdBnATxE0vfdwkASRF/wapavh2qtGWcKW+x8cAqWY15a3SgpoPWJMiBapjLnnycvauzUljQ+blx6yM9Uqze2cKqyjG5x+t4LWzB/v3XDrOAZMON2VCGiMm4+fNX/iAZJYtppqF/IqOAPTdpas5XmqTdD2JAT9rLbFC7r6tHN1gUUxVVgKuX8gvDm/qJ4CEsrKPplqD2mOtr23c6bQ6mM5NGV8n9hMBCwyOWknHLaDWYxS6zhm+mXyNiObuSh08/mMOe6VqpK8yBpI7gEX6Oha3rh+qQxUdofe29o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 15:12:22 -0400, Mike Snitzer wrote:
> nfsd_write_dio_iters_init() splits a misaligned direct-mode WRITE into a
> direct middle and buffered ends.  Then as little of the WRITE as
> possible goes through the page cache.  That works only if direct and
> buffered I/O never meet inside a folio.  The direct middle invalidates
> the page cache over its range.  So a middle that starts or stops inside
> the folio of a buffered end drops that folio.  Then the second of the
> two neighbouring WRITEs reads it back from the device.
> 
> [...]

Applied to nfsd-testing, thanks!

[1/1] NFSD: cut a misaligned direct-mode WRITE at folio boundaries
      commit: cc9bb083d84fd52259476346a852a1e0ef2419db

--
Chuck Lever


