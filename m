Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD161CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96BBD6B0093; Fri,  9 Oct 2026 10:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943176B0095; Fri,  9 Oct 2026 10:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8599B6B0096; Fri,  9 Oct 2026 10:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF406B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:21:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDB081603E5
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:21:55 +0000 (UTC)
X-FDA: 85303301790.23.F4047AC
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 274221C0003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:21:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mhJTBliL;
	spf=pass (imf21.hostedemail.com: domain of martin.ankerl@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=martin.ankerl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791555714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R5SiVnaUQQN34hVlYPHW4REpkY55paPFDk59rozrL+o=;
	b=YlivkSRmqymZZ8ZYB6DvicPcVel+7/GE+/g/Lgf2sNcQ2RlUiiN9w6NHO97E/EsdbTxMXB
	GCel+VO/OnlbMeUUwzr15Tl3aWMZ7v3dUJA8BTJqT/PGIuwrbCHalUqwfmltnlKsbWqOVi
	pHKvL5C6d5liE7dmhZaAbSI7GKTIJ78=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791555714;
	b=Ll2MHHLucxQl6VCumF/ppy+YLY3/iH0V1lfEWzt8yNne6H89Npfb3MBu1JHgNFbB3g1q/s
	8BYqe9KrFeM8++8+lPByvgpe+d25ftwaWYrF9XcycjB3G3pZJ0yX6g3bX+mC4VsgbDHQKW
	OA3k6Ub1l+kEerqo66zsXmioDsP6Bm8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mhJTBliL;
	spf=pass (imf21.hostedemail.com: domain of martin.ankerl@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=martin.ankerl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b16824c0fcso2301207a12.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 07:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791555713; cv=none;
        d=google.com; s=arc-20260327;
        b=Lyv8Yx8Mwz2dJQEvW6JZWBzdSBj4IrkAoGyHfRCdlFIU2tqqNQGjkGme/3IW+o8zds
         hdXtWSOOcgup3tcLdLmDut906JXNSGfYQRJBG8cecXwwcSfPv2NlFtgsLu9ap8xpzVmC
         3xqtmvS7Bvty95Id9OlU/1Oh9R+V3vkmC+T7tltlG0ejWc60nBIHw5nRuKXwOtov58Ek
         BUcsBaA3cCk9phowVsGX10knloXM52l8F4dSUMSEPaqCD62qQ/7uwKYvuiKIFa52ElxQ
         tkPGj8brQOvuWpZRwG4i4b6brAYP5wM6Uy51ALqVwnWEQkmnkojld16f+jkt/zTn5BXQ
         KcAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=R5SiVnaUQQN34hVlYPHW4REpkY55paPFDk59rozrL+o=;
        fh=ZSrbkV6aFmezOvxFllge0sGAhLu32ECZXbMnUC6Kpr0=;
        b=TsK5Z87wzBPUkQlZalqpOg/oRIZn4nkUVkZqyxqoO8JCyfdW9InNvvwKC1kNMBJgk4
         tbHTsA6fzXxqPXMmzN3wpa11qd8l7zFdksScWle0iQIIGCnDAq0ruYeFGk36KmTCeDkQ
         TS9Gfs5pasR1FegVfDso4xevlzLS+1Sm8MUpx7mgqLroDpQ7jemoHepcUWOBWPlkZnVK
         S95bYTeozMWCGErInh7NxgoLHTg6ZuBF4fSyvH7EV6lKAKLCJt9bsKOvn4Wx2LR6owyJ
         03UXqaIF9jSETlfG2OhJBNh4aH8beIBPDmbyZw5uUnrVVE9+8uY68iF7XhUcMDeGeM5U
         GNeQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791555713; x=1792160513; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R5SiVnaUQQN34hVlYPHW4REpkY55paPFDk59rozrL+o=;
        b=mhJTBliL8SCOfko9dYrOoScgbairyJRVVo8VOSUHRItGSk/bihC1Zg7vJU9HMvXQ7E
         nvX5RnDw8vtDb5bo0JeQxdZXPcXTCv/QXczIhk1ujpRKH6Vr4N8B7zDAa7KJDNYx/IjR
         3LXU2n13CnIb6vUeCmIP8P9z7mdZBSwOQlD1zqAVDR7cXPHARD4Lbo3xwiAHpc9pshDY
         J179kjfpKo/5N+4GokoSUZBtCgKEta0ZkD0Sa0d46uAxRA7X3PCd6uS6CHU187tL6aPt
         xghyJckC0TayAbLBr1Tg18T4FpvjFrn6Uqh4I3tQ5AIWqk8QoBU9PNtA9vjiWHAla1p1
         Gr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791555713; x=1792160513;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=R5SiVnaUQQN34hVlYPHW4REpkY55paPFDk59rozrL+o=;
        b=p5OURQ7MGAk9Qf7aUeWW10/YPVyAMlsZrZj5GAMnthVpkmXY+QsV/sVxdyvpUCkEHG
         rjkw8lTG2KzMHcgFIqnWoxlzTWlXyPU59HuwLG9Me6By6K6Kjjr+qWViZM6e+W/llf85
         zkxFFKNl5lrvNhNLQHT92fZMWC8Y/K9qWZB4zhV0BRg1ybXZWdLpmfDfQ5sPDRgPr4V1
         8PwzdzFQW43ihWDLErXE9RMFj847IhIHNpP3ikmRnepa+JG96S+krPKCKjj/H9Ak2ppa
         hFXn6Hi7Vw5Ye+J1/j6CK9rUczp8Ix/Sd7Y/w7IXlm8mi3i3I53TXyuzoeQdaiKBxQ7Y
         P4bA==
X-Gm-Message-State: AFq9FYJBKbtUYKoYcOaDs2hVQkN3YvFwJXfuaE4qACsQsPtjEVcXTfMi
	cc7t9Cz7PZWHJmvIrBwhiFUXHzyOU5/sUWSmdER6aCcBOAM7ewqAC/UgRFU7ghExSlBEilaDK0X
	bTfwlprgpMT5Ic7zhtd/jn4ZivufsfH8=
X-Gm-Gg: AYBFou0QmOTVH7hvIwQgkq3wSP5ML7nbbVWeyGPzjdTjDo2B9ixm2Cf561jXvSqc1zg
	31Sooq5Gl787VFmldy6jhb6UcaTF/ozc496LNbm+2AJbRKSNbYtIaTrIsAPx4slCP58wRJnJh19
	+250LtwOGWkmaQq9TgPA9vhE+kPxqHdFCYtOPphik7AKg4H76Aufnxb3Ki5NKMJZ3PPz9QM5wEU
	OUBLGqg/RE/1KFXSvnNBEF6zQ9PcqUpSiA/YAwshF88oTzY9L9+N7YQ8TggvLB3+phZzJh8xF3W
	3ciqvSkzLgLv4yVzjaaBwEKwTx7R4UUwOLj5JMm9IrhQf7kQ1FszjRuq3EhxWLhwqGIMM3Ii
X-Received: by 2002:a05:6402:254e:b0:6aa:b39e:f794 with SMTP id
 4fb4d7f45d1cf-6b17c28fedemr1748598a12.42.1791555712392; Fri, 09 Oct 2026
 07:21:52 -0700 (PDT)
MIME-Version: 1.0
From: Martin Leitner-Ankerl <martin.ankerl@gmail.com>
Date: Fri, 9 Oct 2026 16:21:40 +0200
X-Gm-Features: AclHuK-62QwvTT56LJQI5jAhTvpHHwM53Qctdf4WmrpYFSOHVx_FT6G7Rry0i7g
Message-ID: <CAAFOosa2WLf--T17cujJu5CUsN12NNjgTitOvno2LY7jAr1gfw@mail.gmail.com>
Subject: [RFC] seqlz: a compressor for zram, between lz4 and zstd
To: Sergey Senozhatsky <senozhatsky@chromium.org>, Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 274221C0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wnqbtoyqnqrpbsmr4sygrxegofts8jyj
X-HE-Tag: 1791555713-981396
X-HE-Meta: U2FsdGVkX1/xpt35Qyloc99Gqz+ADZH7Av4lUFPkd+qo0n1miOjBQDviHpbVd1mZa24qMP048fIDcBS7qeOIsUDTipaJQSPsfZHTR1AFDQDhROMHpCcONtOlJHZVik3mGWx1uae7PXzdJUXvaZKUwGL9D94+t7XzvVKWAAYGfygmPBwGVPQeoKenEcDhCNLwXg5KS0J1Ph2W8rOJyJnOiL2HNKBkkYuccozPJMTcqUt9zN4hm4OOE23y9Mcw/O/cQ7w0P72ryoIpGBDSZX1LCNZVQOkwLbwIPkxqxs7umf8LKwb21fZ9AwT/CrhjSgPm5apZE2qPJn9LeGA9HpaTboDjkUi6FpBtgazomJdQ3F89fyBeeCddINpS953P1aYhttEQDWJqVFWFRzn4MJ1UqO25X21pCutTi6o47jp1XZ6Df5SLI1jE3lFGJDD8ut82Sbf5hmpDDfAZ4lR+Se+tjSc5oBpMqmqdWv2dXZUXTGkByNDFubvlNq2gzJbsH/yK7jZNCkTZ3sKTqRtO7D6MP4Lbk0e3LASyByVLPwlT164i3neAuBGvFG9V9hdj6641ocvzGJBZ7ZmGLFPBSlc1G4xF8Z318goTjCb9vExW8HiMIxi5QLn1THH9RtDaqB2GLThb9RWzl+iCUTqF0JBH9v7pNa/TXhs2Xbjdhu2SUwpxavk9rbRbZtxavi6s5bphmHofug0r1nCZwEddnFvvM0sfJM7nQPwFV6PC0kApqROYT1tdpRK4Z7m/AzjNItHSRelvrML3nFD5EtfT+lXd5w+1EG1GNJFZ+3G1VAgQCer4bejHnW42wW++keWQjIkDLvBo+WTa352NgNOVcpWd5d+t/EN/ToNI5jUGyQJ3rEZLGRbyO5NwurSMQ2zhJYwKahP22putW7q49yixXYG4+u32GsxjwFunTvWOfd2JaO6tL8gMGdp5PKmoMn9ReIU7qkJ/yVsSYkPzDpp5sJq
 lwJ2vp3U
 UVuuik5hdKt1yltqyeLE9lcjrFjOm1MGpeYa9SmUUDipivLDVSY4eSvBZtqrecVGitx6RHW393pE8lOBkSKBO3TtnUq0TUcOIAHEts8JBClsL0AoJBmjmJVg1nhNe37urVzui6pV8MvwoIW9xlbslFUZLRe7MhXKMSfGGP61z0aS+GpopqMc6sXBMNZL49FiHnegpF3n38EjNLz5GYe+tI7Jj2RxSrt4ifoGWd0qqWI8/OUbcRNQhObBIaQm6ffxQ7/c61ok4j7W+Ay9XhWfQIdfwiGkEpC7YX6kuaQ3Ce07DI6F3wJEpBX4vZLybMMoUF0HIagm1Cqxd/NjPCOfG3Vn3yaKz28VXNBNXYOJkgnPrFKJRZ9evGVcSUhZc/V/+OXdULtSQNiRPBWv+epSgDwC2uilsrP+KNQkHOuZpa3QACSCMjWsmNhsyo/RuHTLa0OxWFmi/bSp1ZkLYz0FliiTZIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sergey, Minchan,

I wrote a compressor only for zram's pages, as a personal project of
mine. Before I send patches I'd like to know if you would consider a new
algorithm for zram at all. Much of the code was written with an AI
coding assistant, with me deciding the design and checking the results.

seqlz stores pages almost as small as zstd and swaps them in close to
lz4. On a Xiaomi Mi 9T with its own Linux 4.14, seqlz as a module,
20 000 pages from the phone's zram, the whole page fault per page:

          bytes/page   swap-in warm, A76 / A55   swap-out, A76 / A55
  lz4        1300          5.3 / 16.2 us        10.3 /  31.2 us
  lzo        1216          6.4 / 17.4           11.2 /  33.9
  zstd 3      898         16.9 / 47.5           34.7 / 133
  seqlz       935          6.0 / 17.9           12.4 /  38.8

So 28% fewer bytes than lz4 and 4% more than zstd. Swap-in is 11% to
13% slower than lz4 warm and 17% to 25% cold, swap-out 20% to 24%
slower. With 25 apps launched in turn, 1.5 GiB locked away and the same
disksize for all, seqlz had 3 cold launches in 3 runs, lz4 24 and zstd
6. With the disksize scaled so that each algorithm gets the same RAM,
lz4 had 54 cold launches in 3 runs and seqlz none.

It is LZ with Huffman coding, but with static tables that are part of
the format, so a page carries no tables. It needs less work memory per
CPU than lz4. The format is written down, and a second decoder written
from that description alone was fuzzed against the real one for over a
billion inputs without a difference.

The backend works on your series of 5th October, "zram: redesign zcomp
and rework backends", applied to mm-unstable at fb0fbeb37, and on
mainline without it (986c24e0fe44). Under KASAN and lockdep it swapped
12.7 million pages on the tree with your series, and 34.9 million on
mainline with UBSan too, preempt=full and lazy, no report and no page
that came back different. The zram selftests pass, and there are KUnit
tests.

What I don't know yet: the phone numbers are from 4.14 only, I have no
rooted phone with a current kernel. With 16 KiB pages seqlz needs more
work memory per CPU than lz4.

My questions:

1. Would you consider a new algorithm for zram, next to lz4, lzo-rle
   and zstd?
2. You wrote in March that zcomp will move to the acomp API [1], and
   your series of October reworks zcomp instead. Should seqlz come as a
   zram backend on top of that series, or as an acomp algorithm?
3. What would you want to see measured to decide?

The code, the format and all measurements are at
https://github.com/martinus/quetschn

Thanks,
Martin

[1] https://lore.kernel.org/r/aa9tz-EIh7kOF3RM@google.com

