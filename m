Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3848EA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2866A6B0005; Thu,  9 Apr 2026 08:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E4E6B0088; Thu,  9 Apr 2026 08:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1742E6B008A; Thu,  9 Apr 2026 08:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02F966B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:58:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B04761A077F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:58:03 +0000 (UTC)
X-FDA: 84639020046.08.2F3C46C
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id A228912000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:58:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eZgfhZpP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775739481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHo0GbkrJBYGpDJ/KY0vXCFuOX6g8CR7CnRcWE4JybE=;
	b=Yj7V2kGW/JMBtu1rmiAqVvYoYLTZwGNJLRY+Iq1pzOKNQyhO+bOatKHk86eVfK/Pn/BifV
	yeLBN03tkSVJE9/dZCx9GcI/ijGLyE8MZZ8u+SpzhhezCBtiaOJXvFnFR48P2Fe3oBPbZ3
	6QBg8qCJfFkSGAMa+RgjWh64TkkzstE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775739481; a=rsa-sha256;
	cv=pass;
	b=WxCb1imqndLosdlq7+ypzgtOeYOAIJX2FJSAdqnt2e/v0CXSqot3t8+yyebJhst6LGhoXp
	P8emmFUotPyjm9STyu6sEU6zHVyFq7SB2gXYvsqN7xFR+Jr8unskw61oklIqsp+zpnwVJ4
	SwQAlfwo2JVKnDBXas22trA+pgMLVw8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eZgfhZpP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9c6680aaf8so144256466b.3
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 05:58:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775739480; cv=none;
        d=google.com; s=arc-20240605;
        b=VUhLN5tkXOoyDmyLbtmdIADfwluuxXKva1YDkaByeH/wVopeHK/W745e8Lu4cUVZbK
         45GD8kitsyAzn6FPFLNn/X/mwKGbIuoLjl2in3yyjPNkJY5wCPNIIQLnFiL5eDxd6sc/
         o4hWB8WYy78S5aP1LuC+SEgifBZ8tXeV8rNslX+ixVuMox7ELiSD1jz1MeVRnDJfWbRX
         pi3IqCfC3NuTxtSLFNl0XCXBYbHvL43vMIjCSJTOMErueH4aT+kmmRlnTo17dHYIdMRm
         YDzdhGPlhxYuDjlQraa5dCvQdJPsIifzaAe0VJYMGKIKGT0RYWmp7FPFAa2fwMY8H03E
         AYxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZHo0GbkrJBYGpDJ/KY0vXCFuOX6g8CR7CnRcWE4JybE=;
        fh=pufOkVDHa8PMios+QH/FGflhw7BnUujoU9LzfjGS6D0=;
        b=REGTbdUH/MMEZ1HU/PFeMP8LYKQLTF/sXizgYoqJ8vMpx4dJU6sAJeYsWT6+ykA2a5
         ILlC3kaTKrVGRD7GkUTwA+ZiRqdJoTH2W0bf4+sQ5wuJT58tXzztqOw9BxaCEZqlM5/2
         rquq3XLAOkuj3QsAHkEMGklKfV78Nwm22FoZZi80bcVDQT7VghD7T3p5rFJL0F6CzFWP
         vdRDMyBQpjfqIU+FpEl1WF5pODf+WAhIj8SsyWdj5b81zRhj0bEU5PRfh00e2xfXOBJd
         A+NPVtnK2bmbcnUDhxyx/VAABnzzOoCvuJUunBMxoxNa9eFaS8Q+8BR+mPOke3jKrfdv
         1gvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775739480; x=1776344280; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHo0GbkrJBYGpDJ/KY0vXCFuOX6g8CR7CnRcWE4JybE=;
        b=eZgfhZpPiAVTxT7SoG20ygE3QIEjwoQ3FUTukcvkeAffl/NkD2jYtEWTy2Yp7/UHhy
         iT6QOG+r9pTFfqueaQiHlARmPFA9HELxrjfQ2cLZrv9EZrjVikVqo8/j1PAwLnGxuXN6
         2EH6OxxrHyErAQipZXRoQQgum4T/z6olPxjSytQygZNevKcKCxpyTw3r5W1evT60ja/+
         6Gpnn3QKZywyvGb5UvEW8vy30VVqZY55fafdcEe5coWp0+Ow2HW3P85uaG8RE8Veddyw
         njsSxrFj5JyZ6DO3cKfiiocZJUwaGNxe8tmntiRBj6lYhJO7HLRB/A/lB9OD3um7JBZs
         oYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775739480; x=1776344280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZHo0GbkrJBYGpDJ/KY0vXCFuOX6g8CR7CnRcWE4JybE=;
        b=j2hEVoaZiK9F27hyVbFknK7NpbVuBV86TEBDAELgBJ+1A0O1q8B2tMhd6LFIk/bahx
         VJlsFhTc1EyJN6I0Wu3uOdmym9ApnO0ztLj15xsPDpxV9JcSLojthM24QJ3v/NZ+e5i8
         ftCbMVyy56XqvRVs2wse9Ve/fE5IgCpY0WNQzuN3iHR9ipH2uzjWTzZFESNktNLqlqKh
         1z3z4s/EJ7/zESHOKlH2D3E29LgfoNMTBsiMpDTgi7byMrKA0he312zrbANigRBj5AVV
         0nhdGRvDftzi4zwlC1LxHzGdUIgLTdvzFgaydVKw0CzpEPvp/X39ZNePwkYjg+crpuWH
         KiKg==
X-Forwarded-Encrypted: i=1; AJvYcCUWAn6lT3I9GF1tmap4B7ZFMovNucrxsve2wOSwwvT90FWy7BT+N/pbskXarm1wUIHrwK0HiCdxTg==@kvack.org
X-Gm-Message-State: AOJu0Yy7p5mcau1AuCMOinqSpR69vNuuYK9E2ByZvTvj/UgQ2aommeEU
	qkP1lI1VG+PyCsMyI4IHlDKsOhh8SbuYHMk4XTZF44MUO+q0/NNq/YD7YCkEF1gqsqTxdjTi3n+
	UvX9gjGRLSkzhnMPAUvjy3pMyj8/hA4U=
X-Gm-Gg: AeBDievNaHHXREyStYpeekJt9GfqkRScfelrqfBe2Hu4+4bif9Cg94nwWQpRKck0XBM
	FwH+sMabFz8xEk1c6SldA4bwDWbXlwBSiuq1MUqHFYKssHOGK6VE9eh/U4DNIp7DMVLHiqETX3a
	RHUgS3Q3Hl39EXlFoZOlB1csByeXEyOOoBN8kp6xathmXtZtxyIDLi7e20YJSiZ8Luuc4Iadblf
	Snzlv8HCWMX2ns+dVHVE0lvws8Q/9PesFvHQMXzPiED241uGbfGxIDVR1aZfCMMNMTVLhsoNlAB
	SB+Us0NhO6LgT8homGZmHmqq42KwwSYMofzvQEKzqw==
X-Received: by 2002:a17:906:f594:b0:b98:8c46:fc44 with SMTP id
 a640c23a62f3a-b9d472537a3mr188681866b.2.1775739479605; Thu, 09 Apr 2026
 05:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
In-Reply-To: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 9 Apr 2026 14:57:47 +0200
X-Gm-Features: AQROBzD488QBLxf8tFQvWy4nXPU6xnyCMIBJtuUSx6jvGfNNYZgE0kkI12Vq1nc
Message-ID: <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Filesystem inode reclaim
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org, 
	Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 5dmurnf7n57ay3j3agjg3cey7iw6nrnh
X-Rspamd-Queue-Id: A228912000E
X-Rspam-User: 
X-HE-Tag: 1775739481-900517
X-HE-Meta: U2FsdGVkX1/07cjHIN0s2KKNRaXaMiUvoDdn8sw6KCzzKAEKYELhTNsfgOIp3Or28sjeqC1e1w4kW9a3AcJH0jrB0dwYNDEx+QWX9BinkGG88DXkE6prlVerZ3rywh5o98138NQIDb7alRbXKpwZcEbarl9IpIrgN5Sk01vTJpoL4biQQ9DbTg90V65I58FCKCO02sibtq7DUVBviZ/EVB030vT3mylPc9SSHeWPqcla98dz+J+TnAFnLsiv5rkMTzEgBa7Y84F1UaysQTDp+qaFRYEfNFM7A3V9Ojd3oGky6K6vSPn9gxAZtR6y+HJBLZ4aF9wH1SQ+elMpyOfi/mFcfgUlEaT4t5cwWnkBGSPL8NWdZ6M85wMEHPoi5KLIcd2n0/K3ySkFYYglaAu60+ljA6S1Ggeiw1ObZwzwZBoY3sxokcP87ahxm37RdsTQS9V/7iC9uxXPObUx3iL7Co/6pPsoWDX7PCOpyqWodmCc6N6v8VOJltmIezO9VJ5kkbOqQt0+xdHT8KPFBkjjzYwzAEqCeKfIVrrvEc7WWfIPTNQao0eDgU6yGGtjMbbjUlE5cZBUNSv/0TehVzKGndWMdKZG4TUO1+GAwLSOneqv4qwtOkJNiKHA84Nqz27atEh1D2Zyybcjc4DqZO6Dfq8KnNqGoFS2brZGTFlcX1ZzpPEfOcMdEwAHGV3iukxyBSRrq1EHzkf/vMG/Z0brnB2SGBcVRnPRk1mOEO8QQ8yblm9vLLmxzv1Fv8E+APyFQRrk6RLoRhRvWCuhaTtuNgXhnsR6hffAj5gz7IdA94QeZNdYaTxBT1utYIc+/4wwn3PpdkfUXHEdF8v5WkeC4lS9MHR6Qm58xkW768iX44kidN9MJ6cBcdO3ooYCCurE37zdqfxAJV9T2ZFg8Ey4r7BaO0p6uTHylwq0OvMilyBvci6sL84pLJt09NGKDexQCkTqMTwKBy2iunwbcWn
 ae7LD4uw
 tqNb3oUTqaS0pGXXIYPqcm2+eny9wXwmHFR9gWjEMduXqMtcA/JYFpfCrwx7zDS3UdQ4pps5IY4xoAVOe+5jmzDOLYUb/OnKPCU50HvugbJBqNsGie82wmpEmGZIzNu+iHVzhBmJNIeeTUGK5LrbnW16aRUK1IxNO4z43NsGKaj7HGTOz+MjmBZcF1cmm8kzJrzxKBnEkfytmaa60ozBmtt+8tYl3pbozC+uMBITOd8XqHW4T+pfOWJdUs7jbt+2mfdvnuQ5p3IAnzXyuSFZAnxoXuIxi3vOWAzAEtKkpz8x/EjMZgeClvaaRTo9ghQqH1lYoWhGY6zAhauHWl43c3pxmDGTfolHuuOcyu/hpMhX43Em3qUynbEbn7HHaZjCxPt8rNyhhepi/0MA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 9, 2026 at 11:17=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> Hello!
>
> This is a recurring topic Matthew has been kicking forward for the last
> year so let me maybe offer a fs-person point of view on the problem and
> possible solutions. The problem is very simple: When a filesystem (ext4,
> btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform =
a
> complex cleanup - like trimming of preallocated blocks beyond end of file=
,
> making sure journalling machinery is done with the inode, etc.. This may
> require reading metadata into memory which requires memory allocations an=
d
> as inode eviction cannot fail, these are effectively GFP_NOFAIL
> allocations (and there are other reasons why it would be very difficult t=
o
> make some of these required allocations in the filesystems failable).
>
> GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclai=
m)
> trigger warnings - and for a good reason as forward progress isn't
> guaranteed. Also it leaves a bad taste that we are performing sometimes
> rather long running operations blocking on IO from reclaim context thus
> stalling reclaim for substantial amount of time to free 1k worth of slab
> cache.
>
> I have been mulling over possible solutions since I don't think each
> filesystem should be inventing a complex inode lifetime management scheme
> as XFS has invented to solve these issues. Here's what I think we could d=
o:
>
> 1) Filesystems will be required to mark inodes that have non-trivial
> cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> whatever :)). Usually I expect this to happen on first inode modification
> or so. This will require some per-fs work but it shouldn't be that
> difficult and filesystems can be adapted one-by-one as they decide to
> address these warnings from reclaim.
>
> 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> performance reasons. I expect this to be a significant portion of inodes
> on average and in particular for some workloads which scan a lot of inode=
s
> (find through the whole fs or similar) the efficiency of inode reclaim is
> one of the determining factors for their performance.
>
> 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struc=
t)
> to process them.
>
> 4) The work will walk s_hard_reclaim_inodes list and call evict() for eac=
h
> inode, doing the hard work.
>
> This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> and they can work on freeing memory needed for freeing of hard to reclaim
> inodes. So warnings about GFP_NOFAIL allocations aren't only papered over=
,
> they should really be addressed.
>
> One possible concern is that s_hard_reclaim_inodes list could grow out of
> control for some workloads (in particular because there could be multiple
> CPUs generating hard to reclaim inodes while the cleanup would be
> single-threaded). This could be addressed by tracking number of inodes in
> that list and if it grows over some limit, we could start throttling
> processes when setting I_RECLAIM_HARD inode flag.
>
> There's also a simpler approach to this problem but with more radical
> changes to behavior. For example getting rid of inode LRU completely -
> inodes without dentries referencing them anymore should be rare and it
> isn't very useful to cache them. So we can always drop inodes on last
> iput() (as we currently do for example for unlinked inodes). But I have a
> nagging feeling that somebody is depending on inode LRU somewhere - I'd
> like poll the collective knowledge of what could possibly go wrong here :=
)
>
> In the session I'd like to discuss if people see some problems with these
> approaches, what they'd prefer etc.

Hi Jan,

Is this expected to be a FS+MM session or only FS+Matthew?

Boris,

Is this related to the Direct Reclaim Scalability topic you wanted to discu=
ss?
We are still waiting for posting on this topic.

Thanks,
Amir.

