Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8B4606A329
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QS7KGb4n
Received: by kanga.kvack.org (Postfix)
	id 9AE3C6B05B4; Fri, 27 Nov 2026 17:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F216B05B5; Fri, 27 Nov 2026 17:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E946B05B6; Fri, 27 Nov 2026 17:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 516656B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:05:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F69740487
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:05:05 +0000 (UTC)
X-FDA: 85482280170.15.D93B323
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 06F49160010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:05:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QS7KGb4n;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795817104;
	b=cJo4mLD6SPEahwYnfhjbe5x01BoYkIoRuNED4q9USH7w8xzuBb8G6rCgXReJ9pvd2+kGNO
	JuuIsaBHOIbRC1EKCtHt23861cTX/tzoEWQZXer4+yUr0fPpESG0cOceb0TZP8KfsGKA+4
	ha3eY46C8NYjDqR/YfU7VgYz+ZgW8XM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795817104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VClEl58XM+4yXwL7AVYGyfY+c6D9g2rn19iL32LNkI8=;
	b=klxjNQqDuGWrmzOmhvqnlwDap+2Nm3OBk1ppvrD5i7Oa4MS6cRIft7K6msaxfwrCxEZRhX
	F3dfpiQZGbi5VkcZuXXQr3yTDQj4P3P1JAIP8SGK8IF2DfMeajha7ddBe4fsKSB+p0xc9M
	76oW8wD/kx8CuDndxUpJjicRkirGIRI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QS7KGb4n;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 7BBCE61543;
	Fri, 27 Nov 2026 22:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2BE351F0089A;
	Fri, 27 Nov 2026 22:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795817102;
	bh=VClEl58XM+4yXwL7AVYGyfY+c6D9g2rn19iL32LNkI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QS7KGb4n0K48enlxjXtEoZXYMfLNEzUZc0nrvMlq+RBQfB7wWnMWYI991nx2Zj9WT
	 yltCzx0jUvSe4dkir4KNtrEflQ4W4WHHqhxrPiYkrf7CxTZRt4r/Ouhb9dL6JqcVf4
	 giCouAfNICB2sxJaEcy39Msuzd4reWO9vF4IXzx0c2fbXapZaiNTS8yakNKj7qPUfX
	 HVbiAkMsSLoKilTFCAyBPeTxgs6uA1eeawTTfk4MObjkKz5sSt4Oze4QCvSWJIatzu
	 Z5QoZv3pUaa4PPiiiZr91ZSBRKkmKw0OTVw+hXdJVmzDNMUuR2WvCEG4eRjkvRwjYp
	 JKdgsN8Wm9ftg==
Date: Sat, 28 Nov 2026 00:04:58 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awn-ioAuksHNV-Rc@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127214103.542291-1-safinaskar@gmail.com>
X-Rspam-User:
X-Rspamd-Queue-Id: 06F49160010
X-Stat-Signature: q6czated4ip6kdfto4jmmopf6mckz4fj
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795817103-901037
X-HE-Meta: U2FsdGVkX1/9Z/69+xEqytxlmd4tWjPs2As01FSpl3Z9+UXu6IcTl1z7BluOY5ikAo+6b3LewzgCsUuA5INZTCBZaaSt/9kbVLoCaiMs0F6Pz4vdhSYGC1voI1lmuXGgLvaFYzD5WIgN+30qqPl/1oBr4xhyWkE63qIFAhct6H7RL6Dv3tAMOzeSDvHqZdI3TpwFc/PTuXC1kSjH5nOb48kmkmFpnIYP65go91o9LSA4wcR5xksId7lbMz4qmZaX2bxIh5iC6TuNmKU002efj2L9n2fnqvqAktygPMAMR+KcO5Bg3Rkkp2hv/UgE8U1XVEpxUQWhwQOMgMFpXt383r1hQ/SN4FzPbbsK5EDy8pTAK8Cp6YWp6pEfP9iAPQLIlHxb15KFOwfZnD3tA0D0oFFjp7Da/xZ0wGOrY7yEkNWf2auw78mLmB/+cxcovqv6nW1rFGOLSFhcDmSKZAyl+LDk9ZH6sI/4VFVPFmqf2uUqhDaLhsj8pCWm+9rlty8Xj0EhngFsIkm2KH5fQuSQ/R2hJBrJF0fpo5DBm4O4GLPIHidN1LHWRlewr4SdJpANcsAHMQMkntoAkBtPN/WaYw25SFOMarKKIy3rLRy79o5+ezf4gtGGhpkFUxA8NDK0djqq9lTZ+Klb8+uVCjvAsocY6i87NAvsdy2lG7ZZpPNj5WD+jQygJJh4ZGfW5OqqdMIH+zjX1ZsrQFGu9pCdJWFur0FdPDJq6VsRBjsyzuXeawz463LBHPE5OnTKHkgF8KSDT6kRvZCteQJD38Z3/brhHnGTfFODAbNm0/mZfQrSCAwi0D+Pqm0bn8fxKkU5U29WQbxIw9BykrjdUKQmPBcMVwJPRjjwozLubTphU6h1bvjnqLPiaAE239DYNuRN+UMmTE099KMDC/dIAC8Atc1xEYbn/cAHXVmakrNB4Psb43UckNGOaheJWqxzXpypqqXB4qydAj3a8kqwC9E
 TVb3rTKI
 RSD/LkAs6DB9p2D+Q47WklSum5ypwoLlp7L5utR3Y7NQDR72niPXOtDJhUwNvLGKEurpN4VhPK2vYklunI5/x6mMhr06hRWkh9ssI+ZB317P3KfM/l6A+E3sFvCNM02MovMlmkql4Cclfr8eeFB44+mC5e4fWaP0qqXftw+r3TrdQ/fTYSYfVENp1DDcdY4n0On52xiKAvmh6ArOrjfNtm+9Pkd54PqMmewkmN2SleypMdqfS9o4QGsWcDl0kGGNNrKdy62bGCO2V3smkNkiu8ADQBq9ecXaIXm7jpMdXyPhM8c31rwXcyqJD0IBocDukT50WE0lyzhxRvk7GbqTPEgA0KM5ESARdumrwRIhBoyPIAB3RVV7/+XAmqrQE3IDrv/HzdQrjl3RsttN6ma0zQCOg+ITAY/mWXlk191gEDS+Rmo70O638/BOhnFiiRvo18wfrQoFwIZdcwira/igva/X/baOYwM60RvCVZx4Jq+o2bbYwjVi0aDai/eaCilPfBl6+Y0mxOGvFRO8gGS6wXYXEdU2Id4Bf3VAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> Jarkko Sakkinen <jarkko@kernel.org>:
> > I personally think that "getting in" should not be a goal in the first
> > place. I care more about that whaever gets in has a high bar of
> > quality enough. It can be something different than this but
> > when I read the LWN article about Cells I was alarmed enough
> > so that I had to do this and prove my point.
> 
> I think that Bacik's patchset has better chances than yours.
> I think so, because (as Bacik said) it was tested in Anthropic, and also
> because Brauner reacted positively:
> https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> 
> So I suggest reading Bacik's patchset and say what you don't like about it.
> You will have chance to influence Bacik's proposal before it will be merged.

I've read it through and the way I'm seeing it is that it is overdoing,
and has somewhat complicated life-cycle model tbh. I don't like it.

This could be of course wrong way to see things and I did this just
to demonstrate that similar goals can be achieved with a relatively
lightweight core. And this is also demonstrated with a Python daemon
emulating Cells style containers (and alos relatively trivial SystemD
wiring).

There's no reason to continue this for the time being as it
demonstrates already how I see the world i.e., "I showed the
code". It's up to whoever decides these what they do.

> 
> (Note: I am not kernel developer.)
> 
> -- 
> Askar Safin

Br, Jarkko

