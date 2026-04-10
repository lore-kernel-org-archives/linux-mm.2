Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B72F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4A76B00A2; Fri, 10 Apr 2026 17:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64926B00A3; Fri, 10 Apr 2026 17:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953336B00A4; Fri, 10 Apr 2026 17:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83CFD6B00A2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:14:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27627C209C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:14:21 +0000 (UTC)
X-FDA: 84643899522.29.8FC0894
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0EF69160010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:14:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=dilger-ca.20251104.gappssmtp.com header.s=20251104 header.b=jc66Yoi9;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of adilger@dilger.ca designates 209.85.210.182 as permitted sender) smtp.mailfrom=adilger@dilger.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855659; a=rsa-sha256;
	cv=none;
	b=pIlukLrMHJVcpSnSVYGb/gdEbUWZsJ4aWdnzWPBSJJImxNbj3ivJ5FkfWKNSexIfodDL0V
	NTP8x1pTVksrGFiMTfnVQRRjqNNhGkGmtJwLDMLkL9bwVWjMamzj9WOLhMYSSo8Rm/F30Q
	nTHu1LMrqsYA/1HmR9AAiI+E0RbpYYE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=dilger-ca.20251104.gappssmtp.com header.s=20251104 header.b=jc66Yoi9;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of adilger@dilger.ca designates 209.85.210.182 as permitted sender) smtp.mailfrom=adilger@dilger.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzTjTx58iGVK0DXEntdhFE/+F6BbmjtWN9sC9+eRXzo=;
	b=p+/UT7wi37Chq0MsQc1zv1IbKjO+g8Q5no1Ic/T+UQQDK4k0LzNIPPDj8r0EL4aXeKy67I
	XMO+bgrkk0seYvXDuw7ZuIObJFFyfr/i76Tcef5fEe/AjQCM56f/5OD8/w+vZ+Bo1KBwN7
	SbJg82ttZYTvKzruYdVLAaHtxV9Rnkg=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82f138a6d5aso444815b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1775855658; x=1776460458; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dzTjTx58iGVK0DXEntdhFE/+F6BbmjtWN9sC9+eRXzo=;
        b=jc66Yoi9uJd4SppJKvtm/H0amHSiTSP85lSIRV2OPT0K+jR7/2WWlrjSEOhU3Xp28A
         OhLzZcSQl0oVkaAXD7vcoOpJpdA2GexHAHj1g7P2MJIQEjy+843vq/MYFe/Cb3gxC1RC
         pENgHx+d5rS1Z5jsbf+1XWjtcRGytrPx/D2qMcPxbFOaa1+HZnirxyOr+jHpshNsa9O6
         pEvk+LIvf5YQYXyFy5q9crXaIRkvecxS0P1xgcDnhyeNbzxplTL535WqBjaDQq5ATgl+
         uu5Ltrn05u/s9ttJ8+4sSOrofnT9K48n9dAA6loLAprUHBayhFC5iYi6DV4JvYF8FR1a
         BoXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855658; x=1776460458;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dzTjTx58iGVK0DXEntdhFE/+F6BbmjtWN9sC9+eRXzo=;
        b=FAqoT7trlWyiUIu6/iuSCY0Tfy0Wtt0RgCeJScgXN45OqUfC5hZG39xEz20Z8Xcgr7
         845wf0pLuBBjBRwGZI32jpYa+OTTzvY9/SbMwNOVXeHNRL0KpGfWCWbX3p+xsoymO+uc
         U2wxLaQeIjmWqPx3OmDy604ZcMU4GTm9OJMJHfqFxKWEN5HhRClsFMiAPV2k3zoVopGh
         7OIWAOdEcdduqk8/87pbkHuhTWCT4dlY0kgY6be61mXkFJK/sJ3nZziOD7BEDv8AiF9Z
         Wfq3wlKY2pxmBdkbNC/4AZjqYxUOjYKhyVAcmG8pWygM5bT6kWcuMUam7WkxjbbgIlRc
         zWtA==
X-Forwarded-Encrypted: i=1; AJvYcCX8WWuk7H4+qnBsaMqxMM865cBxnHF6U1FRXpk9yy6jtRNaj2q5aMSc56p+gO12m4SmN6OdVUsdWQ==@kvack.org
X-Gm-Message-State: AOJu0YxDevm/4hNINGDhFz4UhOJ/lIUNIkJ6Wel8HS2bLjz0adRIdbho
	9dvoRFqiPESdkUj5MNu353ZrtUNWZ2EYnJbOApo5E6UeOTtS+HLoUTuyNQUScfruh2k=
X-Gm-Gg: AeBDietjowNLhZE0U13RhC6x1RpN3XUpupnVNSeRMpmJU5KdgwmuZpwmPsc3kA7/Tu5
	yCvgLU6h8Tq1WQZUhaoUzWee/I4Oznizh8JK8qIPqRLL1NPPN+NC5KiQlPYP39TvUe5PowvUQyp
	Ja/o+MubbvEwBhrbJklKraQuHkHNAu8r9H3swJrxhxom7nB5TrXLfCpajipz68wbfTnYK0QuZ6Z
	SNTwI/cMa8yI0UiofyTwb7BHdqDt7ASqMciX5fiRoXifq9IrmjldFsmEfjVyGrn6zUWWfTi7SSm
	UTW6MPgCm7Sfqc3VxnY2f4ouHdvATRvkGzQ5KwexR7RnGgY73MxORvClCRbqshZZfR0waFuRWmN
	fBbWFR6kOK3r4ZRIzvq4NWIghJcjN3mqLNqM8mbM2+Ictb0dElYaZzQhObm//Ow0Eyr0IJEL6Ux
	tTb2ZBOlE2jw8zS2VkL3pi48Cs9rU8RLm05lbplPkvpKG5YzzQwrz5+x5AHXvLiLxv9rZeRxsPz
	IiS
X-Received: by 2002:a05:6a00:140e:b0:82c:6f07:2d8e with SMTP id d2e1a72fcca58-82f0c411dfdmr5336601b3a.54.1775855657677;
        Fri, 10 Apr 2026 14:14:17 -0700 (PDT)
Received: from smtpclient.apple (S0106a0ff70715ac6.ek.shawcable.net. [174.0.84.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0df08c09sm3573765b3a.9.2026.04.10.14.14.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2026 14:14:16 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4q7d2bi2qjg6crznvr55yfnv2gcomfqdt5j2dgkrwp5hh3ynqo@cfgy5o53zjwr>
Date: Fri, 10 Apr 2026 15:14:04 -0600
Cc: Christoph Hellwig <hch@infradead.org>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>,
 lsf-pc@lists.linux-foundation.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1BDB4B6F-D8B8-4FCA-8B3C-FA0672108C75@dilger.ca>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <adikj3y6OXgSyObW@infradead.org>
 <4q7d2bi2qjg6crznvr55yfnv2gcomfqdt5j2dgkrwp5hh3ynqo@cfgy5o53zjwr>
To: Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Stat-Signature: wqj46j51ckrkbe7xxwfbszsa3exznyyy
X-Rspamd-Queue-Id: 0EF69160010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775855658-9931
X-HE-Meta: U2FsdGVkX19oMBdxx758vnKyFJ3uVhJiOjIKKX86PA+UaI7Yr/fKC8ZAUkJJY07snifBEV5cf8KYXNDiFUuhcIveMlp/yFHhn2vuupoXau2uT03P/9YYLzBGBUuXHCg1Es6BTfOWcisUuLvUKIIQOEote0KTT1e2+ZrYgN+/O/g7vI8pfoi/SXEMzrWZXhTvxGy3MR8eovoppWapWPb/mRqeSViAl6JsK5kLjTeK51WJOLmBa0TiCJyGh4lI99yjRMD48NrxpU+5UU/wDNq6N1iBGXIBQZd+EG9OIme6/FXX14RFRl02GEaXt1xkx7hQEnjvzIaNDmhu6+M9/hCi1UiPuTcMYo4EI2c/PWbLZ3YPp6YZweg7adUhAtkV4lQQ6w0iuT1yrE9Um3we8jPpMdKZHJrLqlcvZcv2NMwPZSn+bDshHOaZPhzWv0ol7LyAuK4mhr0k88i0NyaaeoyNMr/I9YDABvQMLukWGcfNQxSmfXF6JpvLeE97P5xmCt8SD9qPEpj7KPbfcssJLO+mn62jf6moDHUMLDzQUeZOEbLjSPCVy6oqOF1gJguu2bZLd2Nzd8HnZfvte3Kv+VLBRs6Gj5fdGoyrbhIAdCKZBDKKLEpxYq7IMhwUkfEzY4hn3kF7ZSGkRbpOZRVny6wFGA7s7nqJalVUbZWP3UGXH73TO9k/p5ugqGOLRZqv8eA/q5sa8LxkVUg4WERT+Rc5UtYtMWhccaU7xcNUvUJrQxMR6C6/D5nyNV5GXdM5yN4qRjLfW68QE+n0JuZkoId/wKkoyzGLXJ9hd2VnZ5QmfNaCUpn7zG7qNPDJPaB6wWIhxPlAmKd4+DOLXFYe+sZPUbLi21kl5ZXLGwOOiagm+4Kof+SfUADqHde4HWG5M6+HBK8INEW4RUl62ntIIjCUyaVutaiW8+Lyvfxp5B8AinDbidrhXUJnfYPVWYPPTaVuieC7ST4GM/3hM/fIv6A
 1gUK1Ub/
 HvqOnD1qVrcUg3Jd+lD9f1t+CYbgHQC/2wSjgLxeCCZBJcDkmU2lam/8/o2pvZ3XlzyEpeZF2z5UA2jOin75ChcAtENFmw78CtprGY8Xmwz2vJn3NZHXXkC9RlLo8Es5MYpTsSDyyfXqLr1eUVzGZKyHXfcvr+fxnLSOKmyCO5PQy+0tm3e58pXhZDyiJqDtTegg2lgCuZSmaitMmWMQWWZ3+d/05BZ7UyR4f5LxknGEujvvtHvAMjlPcPpx2bmG/Aw/Nq5deI0fsyCYA2R9degje3SlINgSCuhfdWeOl4u+Cka5wa+w9dBcrnznnj8d0leuU2JZLJUhFYTUNLQPU4+ZockUG5RHw4GLWbmIDAtNV1vGW4LBDwrmZJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 10, 2026, at 14:56, Jan Kara <jack@suse.cz> wrote:
>=20
> On Fri 10-04-26 00:19:43, Christoph Hellwig wrote:
>> I think a patch is more useful than a discussion here, that idea has =
been
>> voiced multiple times, and effecticely implemented in XFS.
>=20
> I know but after thinking for some time I wanted to get some feedback
> before I start coding.
>=20
>> Trying to lift the XFS logic into the VFS and finding other consumers
>> for it would be very helpful.
>=20
> I hope not to get all the complexity of XFS but we'll see :)
>=20
>>> 1) Filesystems will be required to mark inodes that have non-trivial
>>> cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
>>> whatever :)). Usually I expect this to happen on first inode =
modification
>>> or so. This will require some per-fs work but it shouldn't be that
>>> difficult and filesystems can be adapted one-by-one as they decide =
to
>>> address these warnings from reclaim.
>>=20
>> I think otherwise we call this dirty :)
>=20
> Yup :) I was considering for a while to use another kind of dirty flag =
for
> this and then clean it from flush worker but in the end I decided =
against
> it as it would be IMHO confusing.
>=20
>>> There's also a simpler approach to this problem but with more =
radical
>>> changes to behavior. For example getting rid of inode LRU completely =
-
>>> inodes without dentries referencing them anymore should be rare and =
it
>>> isn't very useful to cache them. So we can always drop inodes on =
last
>>> iput() (as we currently do for example for unlinked inodes). But I =
have a
>>> nagging feeling that somebody is depending on inode LRU somewhere - =
I'd
>>> like poll the collective knowledge of what could possibly go wrong =
here :)
>>=20
>> I've heard this theory multiple times, but we really need to valide =
that
>> we don't need the LRU.  It also doesn't really solve the above =
problem,
>> as we still would not want to perform the expensive inode =
inactivation
>> work inline with the last dput.
>>=20
>> So while this might be worth investigating, please keept it separate.
>=20
> Ack. With the point Jeff made about NFS revalidations I agree it won't =
be
> straightforward.

Can this be opt-in to flag an inode with `I_KEEP_UNREFERENCED` so that =
it
is not reaped immediately when NFS does iput() on an inode (or even set
it on iget() by NFS for that matter, in case there are multiple users?
And a sysfs parameter that makes this optional for other filesystems
(defaults to off)?

That way you could float a trial balloon of an LRU-less kernel, but =
leave
an escape hatch/debug mechanism if this turns out to kill some =
workloads.
It would take some time (a few years) to get feedback, but this and the
negative dcache growth have also been discussed for that long without
forward progress.  Having a runtime parameter with the intent to make it
permanent in the future at least moves the needle.

Cheers, Andreas






