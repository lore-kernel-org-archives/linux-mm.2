Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B1CFF60DC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00F26B008C; Tue, 31 Mar 2026 03:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD85C6B0095; Tue, 31 Mar 2026 03:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6986B0096; Tue, 31 Mar 2026 03:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB50D6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:40:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60F08140BE4
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:40:17 +0000 (UTC)
X-FDA: 84605560074.25.EAC256F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4943D10000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:40:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Bh8r18lW;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf14.hostedemail.com: domain of wqu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=wqu@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdbMiOJBq6EGLnq0dV1kr70t1bjbBhqLXzxcoZ1AKHA=;
	b=H7Vv3n7+N1aeKPYJn5TDrhH3tk1IkMiblVoH8wmroRZfTp/HhixQi7RXTpWnSKepj+1s3M
	b/k/pZAUa9TIE/grJWk3i4u5oSATQEi7uFVPU55iezR+mjIlEM0O5Z4nKkVUh4Z3cyvitI
	K4TfizYcYlgvOG4bf0xOwAZOKaZVyFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942815; a=rsa-sha256;
	cv=none;
	b=K6w75VdHjRDsBePfFL2dsTleAiJ8KD49J6y3JybuW83hSUAhmUDWulnnFivV6kSd6bYqLu
	kGfafOx/Z8rmMkBgFzvvjOuCklUtqFbebJdKbKF5aXaoxPWLJ1AfARHR7+OSpxRUdh9xev
	nSCEfaR4a9L+xmuGN0JkZ7wxsQAnNgM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Bh8r18lW;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf14.hostedemail.com: domain of wqu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=wqu@suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-486fe655187so69960115e9.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774942814; x=1775547614; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cdbMiOJBq6EGLnq0dV1kr70t1bjbBhqLXzxcoZ1AKHA=;
        b=Bh8r18lW/dANQNKvB08ktwDBZFv9kQBQc1IFX7rTxRA3roAJ3HIoeBp6E82aDkQeW8
         1NCfAGIhgL8AUvhEnS0dfxAEvMB0TnaxEdjmrZIZcIR+OwFD7I09f+S0b6SAMGnNga0o
         T7ln+oWH6sHEK6CS7yGgNjOwgyPAGTI7mXMVzXjq+Cz+HjTN/QSYKYCC/xMSk5yRxOPB
         qLPagC558VnMwRWAUnx/fTLu1bdriXfPaRoJD6pnCEuhgswdeooGJGDDcj/Y0OTlLVS0
         GKZw0ru/iOFv5Hcb62x19g/YHutwHgvFBuPnoHCqm9XTzNB7xP4TAS9GNPLQnM2sJMvp
         Gl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942814; x=1775547614;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdbMiOJBq6EGLnq0dV1kr70t1bjbBhqLXzxcoZ1AKHA=;
        b=OiGs40WE64isw4sOnW3CS54sN/FbIlnsS7BSEp7JRz+XL8hAJVtOKTkhvR8T9pLnMN
         gg6Wkk04UFWATx4i3gwYOPSbEuI0S6hJBi3+yyZJlvcho6K+BFjlDB7X+SkZWTaPLa2U
         8+5zRgv7G3h7viX9DOfoqn83oMGps7GZm+kXyo/LPkXjRVdQ4beKcq0FCdperj6nzXfc
         zqZlmm/H6MFzZuu/sWwS8mPN60pp1Ea5F+73YNtteNQ81ide8syWlE7hMU0EyBqK0tYM
         f1Euq4wg7KqG6KHdloNAzp7dehH6BVcGXeBqLyD57qtEt8A1M1hi/a9lWq3pXSeiKRUy
         x+TQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3ba9W4GsirqiOTCIgMbJqKWJeJLYJmTMOLw6CMKFUDfxoR9GyxkS9WmQt+n0nlRYBMRWbLg+TLg==@kvack.org
X-Gm-Message-State: AOJu0YwZBaKfN3Mua4UwTtm7l6p3RlqVkAYZVtdO3q+rJ+h5sB0B8HSV
	z6UQ4Nik+UplQs/INytuGBLY8ppivi+FRztd+HN7IefajjnZmobr2vp3XYhj+oB5qAs=
X-Gm-Gg: ATEYQzy9Dprl9acXUky38PVviyl/VjZjv7rrH/tsLl88p13M/mjtMCM3aOgrAFOnwKa
	pDCQiaZ95WRyhM24+MuG+xhiNYcL+2fn0sOYFkuTC5nqzypsaIOdZGhWohEJT973XhKFR1V533M
	9CKGXPR7lUh+CXndxuztKwK/S2q2DHonmZOgm3/r0+uCtKm5IWLV5zUpl0yn9xkO8OZQxtEup6n
	l7pfPd8qBhqigXyCaGzY8KjJyvq63AaGnCaVJVe1LRfDVGB1muhmxLk+9QSlPpVR/OsJ9VM4+YJ
	dEKzcJwmaIdhwmBdRrOY0Wcuc/MIJDTfUshyGEjacEYuSYk9hBT6C1kd1TfvTv7elNAIMZXBXoR
	ZL4/Uyz/B5R1ao1BITtKeluDZIBNbaSD6eJWPrCIG/vd+ZMwVMDH0OGLpzGs2wUNpX1qUFoPWr2
	twFoXu8QJvc56S4Pzj+5XD4Pg7LK+zGB3GHHTqmZWl6jAYHPRJsT4=
X-Received: by 2002:a05:600c:a11a:b0:483:709e:f238 with SMTP id 5b1f17b1804b1-48727ee5405mr178833865e9.29.1774942813574;
        Tue, 31 Mar 2026 00:40:13 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cda5f7cf0sm1192924b3a.3.2026.03.31.00.40.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 00:40:12 -0700 (PDT)
Message-ID: <c2a593e1-cbde-46bb-a32a-c9db38c62801@suse.com>
Date: Tue, 31 Mar 2026 18:10:08 +1030
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] zram: do not forget to endio for partial discard
 requests
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 Christoph Hellwig <hch@lst.de>
References: <20260331073737.774503-1-senozhatsky@chromium.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260331073737.774503-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4943D10000E
X-Stat-Signature: 4op3fd5awhbp4suxw5em83q73o7tagar
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774942815-690711
X-HE-Meta: U2FsdGVkX18sHMAIUysUJbj0wnPbcEU2g/Aj0bl92ovseX9lvAg1Cgj/5nco8GfHaNIQoJzHOClZHr4VWVF61U6CS2TtXisAMttf7nCf44T0Wr/xsTO54Pq845dHp+xXhekIU6YJt5V1JIY2AAlRAd2ojuN7sQnC4yXjjh2hPh/k7On+BEsl0rR5XEZkcZDUXjdGJmzg3IDniQGKp4Df68COj7VH4yw0I30DVsV4teHAEgn/LHkQ0SEuIYw7BUSUo6h+/+r7haPk9Sj4foN9r2JSAZCCXoZSVNv7CjZiPFzNysxpeA4Vk39bOfu+fOFyfiEHLebq42sVYNVcdIX0bgAH510BL3YvK2t7G6gANBh8fO7DktXVSeE2ZZAiMI5TbnxsLZWnoqIb9Y4LUeI3FKVEfst/5X9foLN/W5gZAU3CutAs9AUCmB3yfYdNlQ2pRPgbV+plfPspXgS7iF+9oEPro8L2h2UmMUvp4YW33DJQOJUG2haAy6GWxmaD7Wu4Tg+CocsJmYyeXoNZwPk4DaSYQp1UJi7LisDgY0c58MJqfhLhSKHLZeLsaAjKXuRKYpF/ekYEtOqJGE88ppFxGKi2AEy/mldgp8+3E1jaz1wmtuVCqFKp8ajYXf90ywH9RxI6jV9/wgAe7NbP78NsIgwaZ7510D6v+AafLuAugx+yAUYDPnO3ya/EkRigbqO9sKhQH0HhhhHXsuFyF/L0T1l8WJ1m6DOEe9mdGthAGKh/OKB7kD6TmlD1w7hQ5yfJFaEhwuFzLTeYKgrOYVQGj16DQ5+wBZ6+liT9PG1dVcDAJHzqW9zMVbpCyEMstXNPl4JGvczwtpXba54+PNUbZaPowN/R9kLvo3BC6HL9VcE88FF8Nf04s+xHcWh3hHvJBCr1M8x9lD5FyXFyOHa+qIHhQkaC94ht2n9aMGGD88/Gn1of0Ag4fOzZPeNHogVOQ7W5U4w2vSudw1FgFFc
 bJgWzRjk
 Tzc8qkzP0VNBpCtVnqAlUfw8wtwUOesrpv3BSFoaDMtN731PstSyVf98uo0svVCfipOBFZiOWD5gYXpay11NcHCIP+/ZQAV9nMpPKsFWMiu75YvuAzl+eb4q7JD25Dr4awKdglWSjfD8btXT/hQILKSjQnmvMzH3ywW9101GGL6k/3+3hl/TXWdMY9PJBPNcK+kN5KPUjdsmo1QbixcYhQgOhARlKWV7O28gKKEtxkc624RogZ8dJgV+BaOGycwvPQVFWT9aSBWBpAOipqjqFNoNjM2qzfaeDuYTe5YRrJEtlkWb+SAZNaVtX5/oFA5F7KvoOVbLILssLhp0HDTKQEEyZ5GU4yQ8Det5sIHL1qzhGVsIT3IqWiAuBxEjLuiz16NJa2UUkZV6G76dn9Yxc2CS9facy6Nu3AOMle0grbPvvJrBp8QCFhVVlhpwSoBumLkBe+2Z8wX1aHKERjDnXupaZ1LQ0kYymRNjgVEB/KXmRehqQSytBI06+bfL3gSTFnH1C7nfoSe4c2lYRNYp8SG6qQC9xvfnym5JX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/3/31 18:05, Sergey Senozhatsky 写道:
> As reported by Qu Wenruo, the following
> 
>   getconf PAGESIZE
>   65536
>   blkdiscard -p 4k /dev/zram0
> 
> takes literally forever to complete.  zram doesn't support
> partial discards and just returns immediately w/o doing any
> discard work in such cases.  The problem is that we forget
> to endio on our way out, so blkdiscard sleeps forever in
> submit_bio_wait().  Fix this by adding a missing bio_endio()
> call.
> 
> Fixes: 0120dd6e4e202 ("zram: make zram_bio_discard more self-contained")
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reported-by: Qu Wenruo <wqu@suse.com>
> Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
> Test-by: Qu Wenruo <wqu@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>


And forgot to mention, I'm just a messenger who also did the triage.

The original reporter is Avinesh Kumar <avinesh.kumar@suse.com>, who 
noticed a test failure from LTP runs.

The detailed public bugzilla can be found here:

https://bugzilla.suse.com/show_bug.cgi?id=1256530

Thanks,
Qu

> ---
> 
> v1->v2:
> - use goto end_bio (Christoph)
> 
>   drivers/block/zram/zram_drv.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index dcea703a6766..aca67d7144e4 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2684,7 +2684,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
>   	 */
>   	if (offset) {
>   		if (n <= (PAGE_SIZE - offset))
> -			return;
> +			goto end_bio;
>   
>   		n -= (PAGE_SIZE - offset);
>   		index++;
> @@ -2699,6 +2699,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
>   		n -= PAGE_SIZE;
>   	}
>   
> +end_bio:
>   	bio_endio(bio);
>   }
>   


