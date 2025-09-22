Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA062CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 05:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22BC38E0005; Mon, 22 Sep 2025 01:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203AA8E0001; Mon, 22 Sep 2025 01:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2818E0005; Mon, 22 Sep 2025 01:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EABCC8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:32:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C1A91A045F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:32:39 +0000 (UTC)
X-FDA: 83915766438.08.44EA2F5
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86D2C100002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:32:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KWLdiA6K;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758519157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KHgPTIbjX+RbMxmT88/7XGBe+Iqw80rvF2C6MVvZKFM=;
	b=HuPn1jQk+2Ke1QKF+9QJIKEyW69QlaaGfHiB4BH8/s1b5+OAQt74jCMWwNBwfVnmxsMSki
	HB72K/mIp0930quN3RBvwDdgLx8MJvXwx79ScWpDsRs4bfTs/gh5QWCMU+4u3Zj6E9pzYY
	Q3pN/TTPECtX/i7M0Ox5jXQOtLOz5Gs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KWLdiA6K;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758519157; a=rsa-sha256;
	cv=none;
	b=OYVdTBaRRfLRWOfDMVFUphg0oOx4TEAZXS2iyvsfELbYvNin7YPBYdrESoGCwZNUiu+YYU
	wxwK1ct7o23bpd1cHSBRR9Fkt7jlji/3qcvnnxh3SetXKLde6YsJUISl7vL0gp3fj+/2LD
	Ux54xubYABHW2ee+cYruRcMC1uzX+lA=
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-ea5c3e8b88bso2737178276.0
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758519156; x=1759123956; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KHgPTIbjX+RbMxmT88/7XGBe+Iqw80rvF2C6MVvZKFM=;
        b=KWLdiA6KeRWW9c41+4hE+fkPKkNv7bF8WWOqNOkglqqFamw1HPtywxBosRbMEzyQyq
         Jhdohf07+3XeYUTrLfgJuh3adRz101oVfeDmb2GZcu7FR9DLa3T3Yley4pnxRh02FKvs
         77olW0cmS7OlvINqMS+1B5W8DaxUqibt5gsPjl10uLaK6VOIb+4yctwV3WQgRrr4i0Hq
         S3i8d6jhebeOedu1IhTSXIpCVg+olAZKvTwTdzclpxZAMgb9en/fYwkU2eTx+qdP3n33
         kUwyqvv/BVBzcwPqFdn6kZ8J0C2w1e9VL4YacJdwiMNVbAoB6RSQpNZ0S5keWrTE5mhB
         0fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758519156; x=1759123956;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KHgPTIbjX+RbMxmT88/7XGBe+Iqw80rvF2C6MVvZKFM=;
        b=WgIxtnp00zB/1eaOMkAB8AiC2k+8Dy/TitfpG+1X4Jua29ECeX/d5mp+kTz/Bbhq+a
         F4JLiAG6qDXG1pnVeEhOuvSVCjiTwXKsZVBwePb6e9Le3LgiflLuC3/zfhm6rHgF4i9b
         uUoja9/MkDpO5MvEYzkEDs7pSQjupsRT9GEzw3hZzCCZUEKq9AnHp0iPotct8727Vrsx
         F0QBUSJMVFxzJSw0SrlWgwKypF3ybxwxI9bunu4l/b81gUCg0q5BkepPW+DCUp5MGkA5
         RS7YROYqE0pFTCZlqPIRdauRZ7RBoTz2n8Wh6hGyUtBvBt4RrvT0sTuTPDjqQcjVewc1
         mShg==
X-Forwarded-Encrypted: i=1; AJvYcCUr/oOcP36Vft9EF7oEWmR9Av9cPtOTFQAfs2ALx0sk1A+TJ0efCY8ToJgNYyMuwEXHDflXfEi3Yg==@kvack.org
X-Gm-Message-State: AOJu0YyhiLGbVudJjeVX+Ey5zA+cILQ6FIcvIdv0oL1hGuxbcj7URsA4
	0jUDA8iHnkYdi0zBJjGM4t7lUGeU223M+QGPpBYHREJwf7Nhhpld45owFK+96XUHUw==
X-Gm-Gg: ASbGnctSQQ+wr2FjQ9IuQsUnj2Snjh61Nw6Qt8ZbxBvLFgAcE7ESGhIqFKYGk06x5yi
	PU/hNnuScvL3hxabbQHKz6VZvtljZwv9pUMOPbDVqjyGROJLmSeleIsv4FCTF96lPnJfgLWoWue
	MiagL/DlfHtluHXAVsTbRamBRdEZV+EfyAthSRkrFRUbb6hCBe8XCNJQF0+Fnb3tJXj//EeYmoG
	65Qjp9Dn8B7uwwVvURw6bacF+uhq8Zpe1Onf/PH/1cvnyiytOXkC1zZaVt5McDBN/qRkfCO15VP
	tJqsyzlWTiW69RCupjbBILgr94OGX+HEPKt69MsMVp+OyvKSoou3zfeLK287RkBQ9qv0yrs9ZW8
	wp+NgSuPgSHoeL+h4WkSIKngSmH0PROdeNTOGdiMRowGl5wTlJe0My+n5OKfXJ7LGWPgoZj59zO
	p7cNHQr+k=
X-Google-Smtp-Source: AGHT+IFzBltc4om+yBhRMAIvW/UzktP2uCRxkzi+JbnUMI7OkFia9Q0opJVxxbuhe9MhVRYr9y+xoA==
X-Received: by 2002:a05:690c:6403:b0:748:a797:38f4 with SMTP id 00721157ae682-748a7b5c11amr44113347b3.0.1758519156045;
        Sun, 21 Sep 2025 22:32:36 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-739716bd8f2sm31249387b3.10.2025.09.21.22.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 22:32:35 -0700 (PDT)
Date: Sun, 21 Sep 2025 22:32:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
cc: Shakeel Butt <shakeel.butt@linux.dev>, 
    David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, 
    hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
    lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
In-Reply-To: <787dc1a4-d0b7-4559-8160-55de987beac3@linux.alibaba.com>
Message-ID: <74e0af46-18a0-8c4a-5ae5-3cba69ca77bd@google.com>
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com> <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com> <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com> <4e938fa1-c6ea-43fb-abbd-de514842a005@linux.alibaba.com>
 <tombfifwrhx2n4jnj2pgcdcpj42mdv7yizkpxrppnqrtsxd5fw@epnrjqgmmy6z> <787dc1a4-d0b7-4559-8160-55de987beac3@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-48439284-1758519154=:2993"
X-Rspamd-Queue-Id: 86D2C100002
X-Rspamd-Server: rspam05
X-Stat-Signature: utanriyr9f7wk1kx65a59nnw1axhiu1o
X-Rspam-User: 
X-HE-Tag: 1758519157-304270
X-HE-Meta: U2FsdGVkX1/5llGnOg7uccaGOMXf7XbQ+rYSFKrmOO3g0tlKJz1ETnfcVqOVoctyUl2fxpFPWhuF+5ST2P+IpYe1jO0fkjh7B+vcUBwdnCPEreYZ9sdmZVt7WR4qg6RlbB7667zwWxtOmrG6SfTRn4rVOfgRLt7ZAKTNWqcCWwU6EuUJVMpxOOPPKtV+0WyT8xnxUnVO3yoXoBcxf2hq1vkJ7EJmRc1npmZLAZtXGz1zz+Lmxs/3c1UCwZW2MsCY3fPDJiDd+LNWSfQpVqq8jhKinLguexx87KmX/wyg7f+VdU/w/dBip7jZibhg4TxH3LJuyBNVIDIqPDvus0fUZI3SMgQbGagoVZBmaZGoLXZS/jXpq5KJyqb9BEtxpR7IMvDfrwRlm1rW1PdjcsWNz9W51hobGVVqTBpw6/Pwxh0Lc8Urk8zcZ7BYQOpSgeW7Qfo4oqlQjxP94qEkBJ83WwluMTGjDBmRcnpIhS6RWkugjM6lLTE72b3Q9c1sqzgFSS/ZfN8G5RebWya/5g7RSYnBDmciJMQyIl4zig5wP4hkcIyqAROmVoL2oLVzRG2dCcbm56rG6OwOx/jvkuqUYiQZj1kbg8bK54vav7Lhlp6H2H8eWvYPFtmA19Hh+WBHHKIN0rm7d2LYtS9X1fybfpuLwuyWK3JnDi9EYBTglhQYRpcwdLN0puCuQ9Ac54h7sU+LxZ9tuUrJ20g8WxLbUyTSvjFqmfMMHK5mzXC764JHpqRO22asRv0xq+xfiwGi2bX8wQ1jrVeZGQ3hWG2rm5HE7few0/Fbk9pwBYNHjjVBWO1O3lWR74B+TeMX9vApgcmbU3wEwZ5RPh8N1c/FR9jHVOzcIRd+JFe8F9uYX437ZfM5V2AeOK4ysSDYXp8vpCuyognRc69WIgUFZ7zwAShrS7wW4Bmuk5HwTroBblfdprgMVFLSCogxFV9axXMFwY1dJzRXc7axuPnk+0g
 R4ON3Mq/
 1XzcOvFKtyDf8XAzE0B9JAYTZK2wizUVzYIuENSMI/KUsb4S8DQPAo30tcRB/JRwbkxUPtpJf0+/S7j0tg4fiJWk9HDiAV0wuUZODT7YTeECUmIK9c4BMANX9DJ4xRwY3ZrcJ3ePoiHTX6Q2KNTFKcPvv7WtK50J9tcxxOSgBa4lUZAmY/ICTXYuyApSGdx+wkQ5WKwQwEFjaRa/EwDCSfKSqDnk8AV14FpOQeoxchdSmTdV6eNjlJYv6L605r13VdVWh/leeTj+LTrjkJJfMwsMIDfpM1I7oG7WLfPgdoLtrc5gzSMoWO5N9VfLm4ugygwQLsR6QCWUFCUhP8EtYJ4nXGe1EEniqTX/qoGnj7Az0m6VE9hypzvCQU8w+p40ezO7yRBg1QGsGNWv9RbQSorpGYvtoyR9mw1FjxWnOYGX6lKFH2bt8EyCHwJ9U5R4idzVq4Ue6PB0HsCyKMVG/Z6FqI1vxY/eztR2x3dReQjJuGbM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-48439284-1758519154=:2993
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 19 Sep 2025, Baolin Wang wrote:
> On 2025/9/19 09:06, Shakeel Butt wrote:
> > On Thu, Sep 18, 2025 at 05:36:17PM +0800, Baolin Wang wrote:
> >> On 2025/9/18 14:00, David Hildenbrand wrote:
> >>> On 18.09.25 05:46, Baolin Wang wrote:
=2E..
> >>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>>> index f1fc36729ddd..930add6d90ab 100644
> >>>> --- a/mm/vmscan.c
> >>>> +++ b/mm/vmscan.c
> >>>> @@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *folio,
> >>>> struct address_space *mapping,
> >>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return PAGE_=
KEEP;
> >>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!mapping) {
> >>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Some data journa=
ling orphaned folios can have
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * folio->mapping =
=3D=3D NULL while being dirty with clean buffers.
> >>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Is it still poss=
ible to have a dirty folio with
> >>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * a NULL mapping? =
I think not.
> >>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >>>
> >>> I would rephrase slightly (removing the "I think not"):
> >>>
> >>> /*
> >>>   =C2=A0* We should no longer have dirty folios with clean buffers an=
d a NULL
> >>>   =C2=A0* mapping. However, let's be careful for now.
> >>>   =C2=A0*/
> >>
> >> LGTM.
> >>
> >> Andrew, could you help squash these comments into this patch? Thanks.

(Myself, I would delete the comment entirely: it's justifying the change,
which is good history to go into the commit message, but not so good in
the final source. And we don't fully understand what to say here anyway.)

> >>
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (folio_test_private(f=
olio)) {
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (try_to_free_buffers(folio)) {
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 folio_clear_dirty(folio);
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 pr_info("%s: orphaned folio\n", __func__);
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return PAGE_CLEAN;
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
}
> >>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VM_WARN_ON_FOLIO(true, f=
olio);
> >=20
> > Unexpected but better to use VM_WARN_ON_ONCE_FOLIO here.
>=20
> Um, I don't think it makes much difference, because we should no longer h=
it
> this.

We do hit it.  Observe, there was no WARNING before in the !mapping
case, just a pr_info in a particular instance of the !mapping case.
We believe that instance went away with reiserfs, but that does not
imply that there are no more !mapping cases left.

We do hit that WARNING: not often, and I've not seen it repeatedly
(as ONCE-advisors fear), but a few cutdown examples from my testing
appended below.

I'm sure you'd like me to explain how it comes about: I did spend a
while looking to do so, but then found better things to do.  By all
means go in search of the explanation if it's worth your time: it
might indicate a bug somewhere; but more likely it's just a race
against code elsewhere cleaning up the folio.

The fact that it does not appear repeatedly suggests that the folio
is successfully dealt with afterwards.  I didn't think to check at
first, but in later runs did check back on such folios after, and
verified that they had moved on to being freed and reused, not leaked.

The examples I've seen have all been swapbacked, though that may
just reflect my tmpfs swapping load.  With mapping NULLed, there's
not much to go on: but index 0x7ff5ce103 is likely to have been
anon, and index 0xcff more likely to have been tmpfs.

My vote is simply to delete the warning (and the comment).

Hugh

[  206.559451] page:ffffea0000f6eb40 refcount:2 mapcount:0 mapping:00000000=
00000000 index:0x7ff5ce103 pfn:0x3dbad
[  206.577039] memcg:ffff888012358000
[  206.584624] flags: 0xffe000000020219(locked|uptodate|dirty|workingset|sw=
apbacked|node=3D0|zone=3D0|lastcpupid=3D0x7ff)
[  206.590603] raw: 0ffe000000020219 dead000000000100 dead000000000122 0000=
000000000000
[  206.597680] raw: 00000007ff5ce103 0000000000000000 00000002ffffffff ffff=
888012358000
[  206.604406] page dumped because: VM_WARN_ON_FOLIO(true)
[  206.617553] WARNING: CPU: 3 PID: 17918 at mm/vmscan.c:699 shrink_folio_l=
ist+0x87a/0xbb0
[  206.623211] CPU: 3 UID: 1000 PID: 17918 Comm: fixdep Not tainted 6.17.0-=
rc4-m19 #3 PREEMPT(full)=20
[  206.634664] RIP: 0010:shrink_folio_list+0x87a/0xbb0

[ 2023.016300] page:ffffea0000d2f640 refcount:2 mapcount:0 mapping:00000000=
00000000 index:0x7f5c34549 pfn:0x34bd9
[ 2023.031613] memcg:ffff888012358000
[ 2023.049601] flags: 0xffe000000020019(locked|uptodate|dirty|swapbacked|no=
de=3D0|zone=3D0|lastcpupid=3D0x7ff)
[ 2023.059626] raw: 0ffe000000020019 dead000000000100 dead000000000122 0000=
000000000000
[ 2023.073965] raw: 00000007f5c34549 0000000000000000 00000002ffffffff ffff=
888012358000
[ 2023.091613] page dumped because: VM_WARN_ON_FOLIO(true)
[ 2023.111727] WARNING: CPU: 4 PID: 30543 at mm/vmscan.c:699 shrink_folio_l=
ist+0x87a/0xbb0
[ 2023.111749] CPU: 4 UID: 1000 PID: 30543 Comm: cc1 Tainted: G        W   =
        6.17.0-rc4-m19 #3 PREEMPT(full)=20
[ 2023.111761] RIP: 0010:shrink_folio_list+0x87a/0xbb0

[ 7604.465422] page:ffffea000092c480 refcount:2 mapcount:0 mapping:00000000=
00000000 index:0xcff pfn:0x24b12
[ 7604.488416] memcg:ffff888015410000
[ 7604.506284] flags: 0xffe000000020019(locked|uptodate|dirty|swapbacked|no=
de=3D0|zone=3D0|lastcpupid=3D0x7ff)
[ 7604.528118] raw: 0ffe000000020019 dead000000000100 dead000000000122 0000=
000000000000
[ 7604.564338] raw: 0000000000000cff 0000000000000000 00000002ffffffff ffff=
888015410000
[ 7604.564790] page dumped because: VM_WARN_ON_FOLIO(true)
[ 7604.564822] WARNING: CPU: 5 PID: 78 at mm/vmscan.c:699 shrink_folio_list=
+0x87a/0xbb0
[ 7604.564852] CPU: 5 UID: 0 PID: 78 Comm: kswapd0 Not tainted 6.17.0-rc4-m=
19 #4 PREEMPT(full)=20
[ 7604.564871] RIP: 0010:shrink_folio_list+0x87a/0xbb0
---1463770367-48439284-1758519154=:2993--

