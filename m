Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA62EFF60D9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8C06B0095; Tue, 31 Mar 2026 03:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282CB6B0096; Tue, 31 Mar 2026 03:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A166B0098; Tue, 31 Mar 2026 03:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 012B76B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:32:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92DB9C34CD
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:32:59 +0000 (UTC)
X-FDA: 84605541678.26.4E6D1BC
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75521C000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:32:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OMQPtSrZ;
	spf=pass (imf28.hostedemail.com: domain of wqu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hqg9/VRYKsGs0VxPUmWgIB7KUuouu96VXwQtxp13sng=;
	b=FITW7bLXgU5J5RUksrX7SP5rZCc0dGK1JCsYRwqA1fD1fAQa2xjdb8Ty7JR8XnXd7DlxFf
	p+Qqdv+JMTJRC661wTkJt37f4Px54aCwseIUZUMZhBY/KlzJJIdvZjzlXcojpb650yL1tw
	Plq9J67E4LKvtlqJiE5mgLFqF5ZLx/w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OMQPtSrZ;
	spf=pass (imf28.hostedemail.com: domain of wqu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942377; a=rsa-sha256;
	cv=none;
	b=dL86RCockg9Db9Fhi57mvEA4m4Xo5967Mooudavl34Guhwe6RH80tHidBqTNtncvzP4iNH
	8vTKGrvnSo/WtZPS5DoIuQ318jOYY++zRkFis58RYRrA7OGqppym3O5Dckt5gK769UJwyz
	rVOmFyjHHXlClcOCMNI1turRDY/zReU=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-486fba7ce4cso53431415e9.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774942376; x=1775547176; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Hqg9/VRYKsGs0VxPUmWgIB7KUuouu96VXwQtxp13sng=;
        b=OMQPtSrZ20xQs+LcoDLtnUAjbx11g6oxrqbqu+CmCPLIwx6XPoan/d1kG1cM9Wx1Le
         Q+PiS47CzxWPAoDs6mvgM8WSVbJeNxTHMCinjnm0c6HYGKaSQSM5xETl5uh0TW/GnTqx
         T7oPkaSmgWerW6HLgoYq0PRcW9lDHYLTentYsdJN4d/lF3S1ncmFpDYX5uv2RAXPhfC2
         dPpq1ORvrdCacbatkLJpK1+hGhRSCxEhHAdKE+t+dn3cEV7AyMfwmCAHYZFF/ILNA6x/
         Xslhw8/JmwpIjjals0XXk5kR66mRyyDU/Gs0jporMvKpA2aM8KKz1Ypc32pA0Mjcj+qj
         C4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942376; x=1775547176;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hqg9/VRYKsGs0VxPUmWgIB7KUuouu96VXwQtxp13sng=;
        b=cFOpvEz0VZy3UNkaCTV7IMG3GLey22aaxGyCXuvyaYNaXfS1lAPGVI7S9/4kkA/aBz
         VcET9ss1osPyJzalBGJrqKyBX1qiJqhN36mjoNchE9kzeyF6wx4ab+r1+ZIAnt8zux1h
         bGVjziNUbrIlW/l1vaNOUhNgqK2hFBMeBouuDGGT4UUjiO02No2+nMRyBM3pehz7K2im
         37LfXjMWWy+oYjmvqhDGk6W7l4qACyItX4ezqK8eL/IMikUdz2iWzwqMv/AfTksGeiXQ
         Y/4geOvihQHhIyligCgwO67tn6RRGCaonZWK0m+Xd1d5ZVhF7mwcwG3VFzpgMJJwRSJ5
         mEZg==
X-Forwarded-Encrypted: i=1; AJvYcCXhTNkArji9dwB9Jy77JgdOubfiDhZfEZmiomH8gqa1h2SxeW3yX5B8bGtPzEecpC6yhfNsFz1Wsg==@kvack.org
X-Gm-Message-State: AOJu0Ywc6iDK9oFZ+n2yBl/xTT4NbVSnfdTUrs01YhqZxV+udAf2L6ss
	3w0SFhJsZfipuCLNiREGJpMv9y3yli5neDmAWO5z4EaSQDSlwyurqkPXC4FrAExGwdf3x5JWwIY
	HyrmowGQ=
X-Gm-Gg: ATEYQzxlFEZLGwTtn0MjjEoJmWuro2Y1ikm9wIQQ+kIUoswGOv6SG0jCVSZOE2gH37w
	AMbJ8Epgu8nOGKhW5bkwiEz6ouL03yOuetvc4JAv0qXY1SGnCLkHz/p6KieuiuhoGyXestgkSl3
	36/wGz/47GkFK1D5iyS17tA/d/s0DiOWyHlpsMVCGrBKO7pHpi+xRntf6qvsveFYH01GtQoB6fd
	+26U+4BD3TOdfCcEYojUaHkvk73vJE+QbeZtEoxnlPbvQxXAO24b+Jkx07oTBQePCGJQ8Q5PdWY
	UlCw4C7XGF+C6d9XhjRrdhgAOaPL8lG1cGtUC8+pZMiKVRWxNsWjvamRZR+9CU9piw1OyUI882M
	DFHMRItVM2hpaSAcacHoxaxYkM4EImO5TQRhxVcSTgdx9CdioBqlrs4eBlYBIjblabCKsQyimpp
	MN7Sh2rOJa5hJjOhtNd68Z5vF48Zke0T6VHdlQQIh3H4PlQSUDThCRXXT7v5BiQA==
X-Received: by 2002:a05:600c:4f91:b0:485:3f30:6250 with SMTP id 5b1f17b1804b1-48727eda62emr245323725e9.20.1774942375743;
        Tue, 31 Mar 2026 00:32:55 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85fc735sm9245251b3a.40.2026.03.31.00.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 00:32:54 -0700 (PDT)
Message-ID: <a6b566e8-5808-4244-bcda-5612760bde3b@suse.com>
Date: Tue, 31 Mar 2026 18:02:47 +1030
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] zram: do not forget to endio for partial discard requests
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 Christoph Hellwig <hch@lst.de>
References: <20260331071537.706139-1-senozhatsky@chromium.org>
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
In-Reply-To: <20260331071537.706139-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75521C000D
X-Stat-Signature: akye9yrq3ba59xbhd3kp4arcgao3o4wc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774942377-370043
X-HE-Meta: U2FsdGVkX1/V6/A/JgL8Pci7u6zeAYUrGEgKr8762rNrC/+mUHfqWsGMDT/jmxk74SAkYw6rdr6PktOPQNnxun5s4zUuXkxuWrk06M80P3fnSm5PpExZjpNkUqWViDRoyvgmt6ojjT1vKvGHCKDlhrg4g09W76VRnHxVuMT8GWj5UNnxZ8tjTKPn7e4Lgcu5SbD46PRfh0cqFa9AhinuPciAZ95geAMosjLDgpZEZy9Nehu2cQlQsDcEzqjjqsQ/yY0H35bH4jkVkBDyvXGWgssRmNOVa3ovfy3O1qKmXXCQPsXWc31cqT4jRg0bLYfdVIpVExs4NsaDuAHB3h3vHtEojEqo2hZky2qnyhnAnFkJ0qPcjJdK38W9ShTmJcuFBLB5Qfv2GToDHbekVmWCuSZgsUtLptUgbteCLZ8lgTU8duhXhRjUqMOprNkdFRLmgf1FSuY5Xtf9nt/Xzm50Wagmw4stYQeSNmS9AZqchIKWUOg/B9mxjCpIRZyMU2V0HRXezd74GFCxZKlyRRblLe6c82J87sRCpgyVj1pN4azxQFfW5QPv0QMO6uIHg3TylQTZR0MkBmRWMo/u/OJCJzzM7P6Y2Madf19ngk9M9UOfQuUlGyNND1zNGWnQ0sEXcCwEp7PC3bkLxWZS8QFEvyo2LFQnH4biO7OrA+fOSFCYTdp0c1wnQM+JsmZw85b9lZl3zdlP8FM7PlzFFNvdbjcScHghq4c//eI86ScymRcy0LkiGjkR78Kjy+Yfs42tSZrm8yeiqWIpbyuCeym36yZlDcZKlsdXyMox2TKltILephGT02o20y9e5o1Ae18auY7a3GlaRBSZqBir5ZzCsMWZ55D+bsYCEMTAzmqnP1sRGIShbDdZm1MIqHxmBil6CzRM0N9Pe9j+fY+9L5bDUgPGqwQjNN/uflj7sP+hlXOFx+SvyHvu6hXyDffJaOr/UB7azKsId9m4Nsu3QFv
 w6Q01n7R
 oJMBhqtP3Nuew9iagVUg0bBRK8sOVaCLcgJ7Y5DUtXdoHW/WdGKThh5OaBC8GLAzZUHrEc8eRkSAa8h+qwMQ66YkfDaWlb6wSM2OF6tKFUmEs8NNlK0NiXP1rjD8WlUzndjK31PLQ39ogonKQisF0CnXc+RToFIqcz2pGiKb7NtkWgXT+xDXNlUIBUwq/NleYRiiQk11rfFhuaRzXkdvv8ADJh6tFGYjAEJMRs6bXAgWz84HPSV0cY9Emr5LF28LL/j9sJDmqq418jMvWC3lEWCGzBMMZmXlyh/rzjutYEgmpCSLln/SKOP2/SkX7Z6+NMcFnsM9/gxZvCIQLuRuzfWCW7CXCfFe3VXl17YLXKVdBRBqWKw0xg4RjJhDDguBjWfmy/rujrouN8MnMRKK4ST+ykFpCN3iNjQ5QTc3dtIfw8Q9O7BX0E7gBZDSaMKaqJmlpQPtIltJTwHUTyUpMMWpD8reziBP9HfIbEfFBLWU1J9Vo+kk13lfUCfKZkwZhobRbO1xgRnDAE7M3nfJrJ2+X7jHn7DdknVW2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/3/31 17:45, Sergey Senozhatsky 写道:
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
> Cc: Christoph Hellwig <hch@lst.de>

Test-by: Qu Wenruo <wqu@suse.com>

Now all discard related works like mkfs.btrfs and mounting btrfs with 
async discard on zram devices works fine.

Thanks a lot for such a quick debugging and fix!


Although I'm still seeing not ideal performance if a btrfs with 4K block 
size on that zram device.

On a regular block device (LVM):

  # mkfs.btrfs -f /dev/test/scratch1
  # mount /dev/test/scratch1 /mnt/btrfs
  # time sudo ./xfstests-dev/ltp/fsstress -d /mnt/btrfs/ -n 10000 \
                                          -s 1774231493 -w

  real	0m3.435s
  user	0m0.005s
  sys	0m0.009s

On a zram block device: (mkfs.btrfs defaults to 4K block size)

  # mkfs.btrfs -f /dev/zram0
  # mount /dev/test/scratch1 /mnt/btrfs
  # time sudo ./xfstests-dev/ltp/fsstress -d /mnt/btrfs/ -n 10000 \
                                          -s 1774231493 -w

  real	0m10.726s
  user	0m0.005s
  sys	0m0.009s

Which is 3 times slower than regular block devices.

And after that short fsstress run:

  NAME       ALGORITHM DISKSIZE   DATA COMPR TOTAL STREAMS MOUNTPOINT
  /dev/zram0 zstd            1G 271.2M   10M 20.4M

I guess this time the overhead is just in the compression so that's 
something expected?

Thanks,
Qu

> ---
>   drivers/block/zram/zram_drv.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index dcea703a6766..b0637423953b 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2683,8 +2683,10 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
>   	 * skipping this logical block is appropriate here.
>   	 */
>   	if (offset) {
> -		if (n <= (PAGE_SIZE - offset))
> +		if (n <= (PAGE_SIZE - offset)) {
> +			bio_endio(bio);
>   			return;
> +		}
>   
>   		n -= (PAGE_SIZE - offset);
>   		index++;


