Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C09C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 22:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2666B008C; Sat, 26 Sep 2026 18:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C596B0092; Sat, 26 Sep 2026 18:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7C56B0093; Sat, 26 Sep 2026 18:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1336B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:42:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FF78407AA
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:42:54 +0000 (UTC)
X-FDA: 85257389868.22.162D8CC
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4ABE3140002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:42:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ST8alUZ+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790462572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPvBitOMBlhp8Hdy1YMUl7WEgUJJU4NLUnrbTGzbCOM=;
	b=sC7fkc8H6IPcN8dGYZqVK/8j2NfwEu8/PSARQzKnGdUTpzkPf/1rB+G/BcC7Lm+qGbX19j
	YBPllU/N4HxDCt2iKTWiB7tYoGvHOQr2jrE1KmJ1555+TNEUb/lu0kCK73lzvvLNI1MdBD
	emfnrTQMvo4FG8f0Z/TOrfzzJTpZHGc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ST8alUZ+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790462572;
	b=bSZRDtY4otcZMzDKFmAiUMstfKpvQd+I1r69hlDjmbzHC+qX1UAVjQ5Mq6L88Orh3k1X3d
	pW9a7KQVq8/yjA5kae5rAx2FpygOGYvj7g1UGvs4/6C/iBsWLANdLPu2cJwh4L0dCK4VI5
	vxA/EPDS7wi+UxS3OD0VXqx7F06Z6Ag=
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-91434eba57fso14098016d6.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:42:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790462571; cv=none;
        d=google.com; s=arc-20260327;
        b=cJK1KS0hD+nwTZY5FSamAJ8aoZ+AmhC1+V+gtTOPUatqPBaASuxeDtOcmOmbbgbDc+
         qO8CB0GkHRxpblBm/tr7zdcDd9y7iSTE73awX76WfX1dl8mgtf6pRiSlgi1HiqSAVWD/
         IpCEgk1gEY4FsuG+hts5GQmtEJnVAK0y4e4nENTY5INEuYRETfuDBcF5lZ5K2kBwho5Y
         t32MG6ETuGHnqAPt85UuYrWUy/CVNpC89FzN97gksLDJIvO/Ak/oofSdeRabPb2m/w0N
         1yeTvL3Bwy8CFWezKBJEe78dLpOBjBLBWn2yPmYQP7QEiIU6ok2GJ3ga3p6xEdLXLMBy
         vTKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=oPvBitOMBlhp8Hdy1YMUl7WEgUJJU4NLUnrbTGzbCOM=;
        fh=ugsJC/Q1Ecpp4qotXHvAvE9viuojWnSRGAADEoEogLM=;
        b=n+/9YYNLVqzULzQthelZ79KoBUjQpUVBhw9g3JL7X1yxmd0cpFE6ThydgkbcdB0Qtj
         3noX2NcDPW3c1MZua6hrwprVQpqu6SE3o8HmXsQUWpWlNwyxlotPTR9YtPa4Qjg8CDgN
         rr0Ev3wJG/tXRHUumY4gidp8CY3WgdAhJvkmkLCYdsjBTvcIERdP+c9/PEYXsy/T8Dp4
         5FwVz/4a5+5JJwIO4ZdWQ/NOBqGHnj+Wi1tNs1HIlxhmxZNjhIs5GP9pZndOP47BdaWh
         uzS5fKGkvuz/xbCFmllCnOb9XfE0Hrohs3MPKIXPqwwtvo4TDOCNjTc5mp88DnKMweDI
         OtXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790462571; x=1791067371; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oPvBitOMBlhp8Hdy1YMUl7WEgUJJU4NLUnrbTGzbCOM=;
        b=ST8alUZ+F2zzKKwpIHEt80Zvp5RUCf6GsAMT3/GlS4EOlv53tQrAwT0zvMA8VVt3f5
         jJIED87+2Vf2lB28cTAnXUhRctcaeVdoiQOhhZo/bjiLuMmwT96nZhl9JIVgZLbW2z2q
         /tgZxir/sA8Nc+r3N84Iwz969UgubDg/GcEshPnhFZvPt5JUAKj8zkX+v607XvyvAnkt
         KfwncvZpkNVKI4Z2d7DOts3EL9fTVZIfqNLryHQxu1FBPzkpL0hIWADX2flDE7jt1Qze
         zk7XxGgBlP338wWe1cqmW4gnpGVky+33YL8rxsvGWs+XbL2N/x9EfMLJREcIDCP8rnyH
         KeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790462571; x=1791067371;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oPvBitOMBlhp8Hdy1YMUl7WEgUJJU4NLUnrbTGzbCOM=;
        b=CNUaaG9AKSB/qr5pN+4HfTye3HnGayV2Z3qkx5lMlQLYN+EytZpTImJEbkarWj/BrL
         Cg2IGKJ/Rw7JW6qReDVsbjeGukrUys7Jjcrf2Qt9Jd45SXK69Qvx16h9GGoWqQP4398/
         oDLOf0UiD0rGeVg0Cn6bTvhUwgPVVp+5/vGCYAAB3hsNme/8UwrqnmrahtLeHrFvqaZm
         GFBue4jxAmzZBWSrLLpOTnFL/t9OSXaqPx+EbeYozZjKRoCrC/v8PBKAkvOXba8bZTF0
         heklqatx4Kptv7PPSJPL3dVHdY84VbO7o6toH30LJ2jXqo97pi/KMlFLvsM4nxRoMuz3
         Ah4w==
X-Forwarded-Encrypted: i=1; AKwUvBzc4n12vjmb5GqyoCwUviHXgLJ9HSCdBWfjXUIiOidKEtq90j5iT+uSUnBY949yXveTMXoQ6TzcQw==@kvack.org
X-Gm-Message-State: AFuF++nowTE/+udwyGnbVqxLJRL6zlAP8D+x8C6XnD6npLLPZHY0OX4q
	JBfxEhmbhc39eqIflS/4KXhd2qYPctt7n+q4vZw6w8TorBHURn+mGz75hUHvGrmpeb7f6e0ObM+
	CUzcvi0ofj+io1aBISHeXbt2zq/+pluS/P+YMKznI
X-Gm-Gg: AYBFou2pptctG7WdbGmg+pZXtH7Pnk6PkrDsZxbLyrsPiltURSBWxBJwj/+kLUV8vhj
	s/3c3uV+9UEKcp6mskHrfsTvvt1aDRbREc4JdRbOOAvN7ekjCQavUGuWKqNGv6N+oF4xJ9wygZv
	uXUgptFlqCdFVq+jboTOt8N3XwrAL1aqoVJ+HvWNiom2TgO6XOjzcAL99sIOPiYZaYHNDKy/5va
	zfoTAkBG0zzN8zdleZ/zCKJuHzNy5H5ILU3FdAXCaAiMqomS/EAEuBXZsok5WDI7SoSVSWLrJun
	vYQXiXPbZ9DdAavMa9EgnF3KHjISUri0yrYZQ8SnyrOyOousxfBokkhrE2dCeWQkEH1h/SC3paz
	oMS2SqgTLS+exQbKsMZcP
X-Received: by 2002:a05:6214:419c:b0:914:4464:41ba with SMTP id
 6a1803df08f44-91444646dc8mr70530596d6.26.1790462570563; Sat, 26 Sep 2026
 15:42:50 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 26 Sep 2026 15:42:49 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 26 Sep 2026 15:42:49 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgHZTYUuFBXS3sGyyjiveQOeLHuPxvud8o+R3NCCwM6Ukw@mail.gmail.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
 <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
 <20260923220912.46905-1-kmehltretter@gmail.com> <CAEvNRgHZTYUuFBXS3sGyyjiveQOeLHuPxvud8o+R3NCCwM6Ukw@mail.gmail.com>
MIME-Version: 1.0
Date: Sat, 26 Sep 2026 15:42:49 -0700
X-Gm-Features: AclHuK8P2H5EpMJy1YvK3gvIP-rpUihsCxDjwpAZl1LdwcYKlVTgraMVSJkaNkw
Message-ID: <CAEvNRgFPpigP6zq+6+dvC7nubFBjeYNZYPj4RHB1uXd6c26H2g@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
To: Karl Mehltretter <kmehltretter@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Zhao Li <enderaoelyther@gmail.com>, Jinmeng Zhou <zhoujinmeng@bytedance.com>, 
	Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
	jthoughton@google.com, rientjes@google.com, vannapurve@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4ABE3140002
X-Stat-Signature: z1e61r7et7hjjyb714f3iqkztt1godha
X-HE-Tag: 1790462572-995226
X-HE-Meta: U2FsdGVkX1+FrDt+kFuSpi+eskPkdgSxMfOeRaSZZmCx8tRY2jHOWL9tgSAWEDFW+X0Bu9gLqtbl1NrsyE7NTIM2oc1jwP7kJKHCnXes8p1Zr3hzj2Ljq13YgFqQ5z1p4AjmZAaidF6ZdCLyNJ3FRjEEfscm4/Lzjw69nFEfUufP0r6ZgidKrbe0No6nLiWG8KzShIsFUcRa47TSpc+C7TU4LvU9t/oe9dVegcYf2gL8Grlgo+ZhULKnqjH0iwaeU6BNbsEE1mxklCEp6nVy/XW8OSMMTz0OR7UW/D77CQIpok/Ohg6Qpgp21CFBPiHXsuVTB41fqloYcdXj4Vgxtve4vGU9CE/B2fllV0ANT5fyQJT1Jxj3YdbiOxyMeBehQMR856wLnxSZaLmt2rUd1+ZE3Ifr8MaaoE8wPempCZyb01Qn7vRbordZqOlem2eHd8BBPRxRr6J38QQCqdhwx/mG59W0eNcgMRR6lxEF/HYAPkn010Wza9qQRY1IvqAvzONNn7+yVKxMa3o16qGG6jWVMTf5OAxZtm+BHNhwKpN1AnelaCtu5SnQoL4U4hrti3KlKwqJKZWzivYJvqVeIy7t4t3lgwiDeiDk/DKMNLSRK/bRBXv0Sp2MZtOMfX9uoW7spu5yk6V2H29fK0FqBnSCpoh0XM9t1c94zFmsGhCNzL5bfZ7uMIi5pTI9hgZTAHlrz1rIaLiyO2OB1TOKlLVx8Kx8fjUXBAeW/2vHkQbvjvbEImB+zSBzFItTKuMRDECRtSPbwXsR0nmuWCLvOZlg55MXZBmcaisa5QURRlwV6wNyxkXPYg4RqNaZlCixZz+Jw7JMAX2CcqiEw0bHZ2T5w630TeVDlRXQ/XTLEfOdoPGMVM2S/ygTWvP90+m62B4q/ZIVMOLGjtgrEgyR2PB2sFMcIDn8AYJ+v53oSdkuW7J+1pQReoGrpcwP1Qk5ZqQnbvgfRETEkIrLJ5a
 hnLyk9Wv
 5WdnxfQikRKdrgRfZDpMFrRLxFa9HYm09EiA3v6TOuD0anJblzTCUQheg/tq5XPSTQHTbvuiMJUUXRYcEYbyWs5ZS1h4FmkxdL6gxlfbrTwkaGVULCQ2I/LCby2tUOoTYY2RpJpxwKbcnVapAL9WyytPObHCk2TYjeuMaCL55+MN4TVrWDUN/4VX+z2bCrqfZyIME0or1/UtSqM8QxTHoYt6e9aOJSlThjwBKGv+0Yggv3GvUwhUNyke34ClSEYITRCDDoHlsiCIGoayLOVTL17HSdfmMjqo6FgXZcgZDYx9ZbjRrd7rOR72q1k85zg7gCrZdTHqtN2zdf4HasEOTCZIXbw7CZ8sEJOhIwColS5G1ndrCwx4SRx6y5wiT7qbL8UviJmPHbaZLDmDjvp1d6rCAA0XhkrIB7U9HAA/7gZshUC4kJoPf4gMdd0BUJhwTM8FV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>
>> 2. On splitting: 1/4 applies cleanly on top of both queued fixes, but
>>    in my tests it made min_size-only mounts worse on its own. As far
>>    as I can tell, that's because it starts tracking used_hpages on
>>    those mounts, while the two error paths only release it after 2/4
>>    and 3/4.
>>
>>    HugePages_Rsvd, expected value in parentheses. Q = the two queued
>>    fixes, wrap = 18446744073709551615:
>>
>>                                    rc3   +Q  +1/4  +Q+1/4  +1/4..4/4
>>    min_size=4M only:
>>      SIGBUS faults [1], no files (2)  2    2     0      0      2
>>    min_size=8M only:
>>      failed mmap [2], umounted (0)    0    0     3      3      0
>>    size=8M,min_size=4M:
>>      SIGBUS faults [1], no files (2)  0    0     0      0      2
>>    size=10M,min_size=8M:
>>      failed mmap [2], umounted (0)  wrap   0  wrap      0      0
>>
>>    With 1/4 alone, the min_size-only mount loses its reservation, and
>>    in the failed-mmap case three huge pages stay reserved after umount,
>>    presumably because the subpool is never freed.
>>
>> So it looks to me like 1/4 shouldn't go anywhere without 2/4 and 3/4.
>
> Thanks for testing this! IIUC from your table, 1/4 introduces
> regressions.
>
> How do we handle this, should I squash patches 1/2/3 together, or is
> there some way to use the Fixes: tags to require those 3 to go together?
>

I think I have a better way to organize the 4 patches and the two
already queued. Will work on this.

>
> [...snip...]
>

