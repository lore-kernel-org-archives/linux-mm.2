Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C794DCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48446B05DD; Sat, 16 Aug 2025 10:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9666B05DE; Sat, 16 Aug 2025 10:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F346B05DF; Sat, 16 Aug 2025 10:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4026B05DD
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:03:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CE041DAF0A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:03:58 +0000 (UTC)
X-FDA: 83782789356.21.9DEAC7C
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 325B4140009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:03:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aC0Io+vD;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755353036;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JW3v91P5CwbFWimhDVDVIUdXyEBjGDrDu9hkzktRq/E=;
	b=2/ZKLr1SBc2G+D1/f/TnaajIqnBSzYbVDEsBgYIcSCY7fehXHsLbre6yru2gqQ9+p6u1K+
	TSGiRLqB5Ut7pcfLi2oAbc6QtJ2ytcDGDQ0+wn7DoK/awWaDJQ1iCzehtnUTv0XztjXFVt
	zFsPQcXZO1LIhTue8ETp/SoOsZJWEso=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aC0Io+vD;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755353036; a=rsa-sha256;
	cv=none;
	b=EYEWOh02CmWTTk5twQBkwPieogMcEcnO3n8c3ITo455edyzPs9b2/eBQMFqPthDMuSn7fd
	0ERaCN/UWtXhVvG8mZJkBlvMAMjjizLskVVqVx+tufO0z20ARqkDLVY4lmsRTFXtrm8L/a
	4Hm9+aCIaOWQso8VXlEqd2xSTaAvj+M=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7a2befdso405332466b.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755353034; x=1755957834; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JW3v91P5CwbFWimhDVDVIUdXyEBjGDrDu9hkzktRq/E=;
        b=aC0Io+vDfi7nz86xAnAQgPWQSXe4dbAZugMAzNg4XEKAJLxZPPZgLoTYHj7D+HpVx+
         jlY8pJjR7gOsAP9zXcUyJsgymwhPFw35YD7Td+8P1mpjNYQhBK/ScDrlOZqeSOTdZMOk
         UqvI5GH6Hb8QtKZol3/RYatIrKhaHAd4JIrmc5M4pgSFl1X9pwcPpEU0GnE5drKkPBmd
         MB/MpS7FBetdTr+EGbZDxBDYusfhH2Nv4LLNx9gwX06EJxIrCnhYLS0ZdHH4l6Ecwwuo
         XGMjyYINTahtjiUenqDTwK/EG6uUz2FR9U8/AjUGCs3Oy130a0r13tTrWUADmmSRS4DB
         hk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755353034; x=1755957834;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JW3v91P5CwbFWimhDVDVIUdXyEBjGDrDu9hkzktRq/E=;
        b=P5HIEaokeZvUj91P6PR6w6ocOXXIus3a2oI35/H1U0sVeUou2niPF4g+A+QvF1qCTf
         lf/owGZUo572qUVADwn8zGO2pVhqruqSHc4ZamFIpbC5vGoloJm+g6Em5TzpUB9VbrMd
         mfj1LAC0rGwZeLJ8qee4KrWpTa4nq0IO7d9r1jmB9yyjQffmvubjBLiktdyUSPpcdjhm
         BA6n+VnwcQ3pZe8OSILaQNbh5MXNRQz0ccmtygV2x/xs18j+2cCitoiCU6TzHgzbuo6c
         MxpOLpVaLG7EwCBE0MjEY+ZIeCQjlpJkcNmms0S22jeFVxJDrzrny6FALQLU1pmYOwNZ
         4qKw==
X-Forwarded-Encrypted: i=1; AJvYcCV7OZP9X8uCV38xD9HtqrpINVaHIkL6A1D29OhpD/3ikUW6hr27NBAh/aZT5vjGdadtVAogeULgFQ==@kvack.org
X-Gm-Message-State: AOJu0YxTbfAwSkSblv2Cg9/83lFEGkrjllAqaKFbeZ/pJeJIvq4uZn5a
	yMfjcHEITazqWdV9G827ZQC+zL8uaEvsGP6anjyMPSPsDP1k28AammI5
X-Gm-Gg: ASbGnctSL4nFk7CV/couDK7ZQclhAqnLQkM76sAOazykF5vXMWtoDPB5Dvo0WO+W56Y
	Qe+c4jXqyG3Mzku6ybo+RfstDaca6qfySLDywIHnYPYy0BqBxSj44s9fnIAsB6N9lkS1ZRIRILu
	/XQkvmBNaMyxo5DBvzDAIIjMFY28DoE+HUaqazxN88n4WLeQ46n23f6rD53RQSgscome+2itPwB
	j4kj8UIJ/e/qdu+jQMSMlq1pXtzLLFYvYpwqpUyFRx4byDbfzOLRqe4I7kZYcTkuzc+EjKNR5UM
	3mo4DDLeV5GuaX71h19Kp89DVczPFT2N1XQRC6HUrlfuLZ3y8cCY+kz0KJmJdgiQQs79kecNfLL
	U8Gh5XO5pAlhOUJHPiJsx8w==
X-Google-Smtp-Source: AGHT+IGL2LQroQs4fsZsKFvmg5dmGFc2bP+1NPhKm8Sd15Id1oMe0o5A49dNjwUNFdZ+aO5DpOjb+w==
X-Received: by 2002:a17:907:3e1a:b0:ae0:35fb:5c83 with SMTP id a640c23a62f3a-afceadd73e7mr244872966b.28.1755353034315;
        Sat, 16 Aug 2025 07:03:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce73e22sm399471466b.41.2025.08.16.07.03.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:03:53 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:03:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	akpm@linux-foundation.org, riel@surriel.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/rmap: could be partially_mapped only after no
 entire map
Message-ID: <20250816140353.tgu5ur5o2n4aic6f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-3-richard.weiyang@gmail.com>
 <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
 <15ccbbb0-8ebc-4c50-a1c8-fbe5416ecf46@redhat.com>
 <20250816090654.u5eoys2vkpswe553@master>
 <88117e56-6b81-4601-a954-26d5f630aabd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88117e56-6b81-4601-a954-26d5f630aabd@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 325B4140009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yqjw7k3pg9n9xeqyr7h8s9b79qkxah1n
X-HE-Tag: 1755353035-850376
X-HE-Meta: U2FsdGVkX1+hazA09pmclNMvRZlSpR+N0R0C6rM8OKO4+evIvi9vc98ZG2G73yHlUw4qLxOaZybFdwYwlELpXu90DBByjmH14ErB62fhPOwKPEZ5KlBNGqB/ocJeokR34Z0U8xKbz9DmE+5ipSvnaWPvwt1uZW3PAM3lLTQlIyP+tXDq/OtgBSG+zgYP0PRuZz6ynBmKISlxAk1dvY8DQzLvow7TFsnEsIXMQ7GFaRvJHF6DXq+8PlelTa+oKKHSMJEw04KWZ03ESg7Tu3XLIVExBih2qGqVwc1dYW0Msdae6aJO7pLYUv0Os1ywMJAnKpZ99ZteERTNu5SJzB4jeLrC5P+rB61VR2Byj5pUS/9t5t7NF4HLHy6DabP0bc0Zjq3Usway4jLsv876gyKCu0oJ6a6nfCVss5VWzAXRvRxLvl35RdKUyJzuI3QeqjLXcPa9JLDgXIpiIFymFQrNvA3NsvuodjJYFcONG+z93VBT7veORrOFhR68QyGsxEBwKtkyPwX7SrBxlITvExHJQ2vHR02b4WZU8SRUAN/I0R8GO+eoeHFChwLXQgRxVVVJEX4w9pMkzhgEqbZ2+yvFlqgCM7IJccbFyj3nOc1XRuiXgj2ggZdVcLnUdhyJWu7EWeEX9v5s07EHsRwYrMhTkmTQpobreRo6yk/jS+2hm23ioF1dH+Bcor8QSy9DsGyipBhDxVPkHw6Dal4/qVIua2qM8XbIjPGzWsKCNOCZXOgJNcHkllugjkSPTWQdJTMAfP1jkxbjhObFvUkiy6ampajxSZm0LdkGz4GfkQjd85LjawWVnyZ0slwPqX5fLCMNcTbh/1sTEBt0Q7y+u5JT9/ipzLfhZfy9o32EHFjTbIoMAkCfDtGhB9oVlYYLtn12dvMKO9reaXR5fRKQ+USm+0bZA0k//o10yn/REH0BtfKG1qszwHL82lnUghHBX8a7T4rnTMElX4QnWfSJv5V
 pQ5p9Kj/
 wOUWOlU5+Ri+A85SEQ525pKJyFSbTFbV6VMo7G2lU889+apU8DRzaEWdN8OwzizV0yP/wNcNO1M0BvDW0y4H/Abw5++x950Ytv006Mlui5VaptqjTtd3lM5mw9BqYIg0A8lfbiqyxL7va6UAwqHdthI68FYkOfEgdTEmM758PYZAFsUBjLD/8OKrOv2FOKimJ8VMrGB33qk1a7XTiS1MaRLvIk+TA9IlRxv/YRf66BQrX0kogwIhXX4/it5ia/QKCiUVfFF27FkiVTn4MaAB9YfSCg7VLluJ6GvtN1UmCq9dKf2BGoKLOVYdNbXK2JdHMVRuNfAhy36Cfq39k3ZLKmuikQel2rvcD5i2c2dh41CZOYCoA6fuQmg+IOMRDcOFmw+9fipKAOaJZg24UKZIas91++cLrJ41z/rom9N0A1gaSU49cetdgdP+OzsvPa9HpQ1dNUkW82bTNq3VKCrPrQe25l8OlntWm1q4Kw7ZOeCR5cJJi6peLPq45Sxe13B85aqaAI6/7pjQRHEYS2EIPZ1gU/65E5fz3iIb4/nB9Sh4Ij0r+7BjGVvr6t89RUIv6avy4SQ6NYYCRhq+U5W7j8vyJQMTh5phGlVC+DJ5rNmtrXs4EyJ+Eg4fLFnA+iR9rJbCHbD9IDS6aZBH1B2zxIJtzLw5v1xHfPJHsvOCjIgD3gaxgMrce3WgZdHNfthA+FEpNJBhKNKk/Z0+oAauCwqFaT8FswBa/5Zld4JAwwQonVgfm1jo7YfIe4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 11:16:37AM +0200, David Hildenbrand wrote:
>On 16.08.25 11:06, Wei Yang wrote:
>> On Sat, Aug 16, 2025 at 08:31:59AM +0200, David Hildenbrand wrote:
>> > On 15.08.25 12:08, Lorenzo Stoakes wrote:
>> > > On Fri, Aug 15, 2025 at 08:49:42AM +0000, Wei Yang wrote:
>> > > > If it is not the last entire map, we are sure the folio is not partially
>> > > > mapped.
>> > > > 
>> > > > Move the check when there is no entire map.
>> > > > 
>> > > 
>> > > This one I don't like, you're having to sit and think about why it is that
>> > > this would be the case, vs. just unconditionally doing it.
>> > > 
>> > > Again, as mentioned on previous series, just because we could do something
>> > > doesn't mean we should, unless there's statistically reliable perf data on
>> > > something real-world indicating we _must_, code clarity absolutely beats
>> > > everything else on importance.
>> > > 
>> > > So yeah, sorry but no to this patch, please resend with just the two
>> > > reviewed (unless David radically disagrees with me :)
>> > 
>> > The compiler can figure out that "nr == 0" if the "if (last)" branch is not
>> > taken.
>> > 
>> 
>> Per my understanding, last is a run time value. I don't figure out how
>> compiler could help here.
>> 
>> I may miss something. Would you mind giving more hint?
>
>The compiler can figure out that it can move the whole statement to the "if (last)" branch because it knows that nr == 0 otherwise and partially_mapped == 0 already.

Wow, this is interesting. Compiler is smarter than I thought.

Thanks

>
>Best to see if there is any actual change in generated code, though.
>

Take a look into the generated code, there is no difference.

>Note that if we're already moving that around, couldn't we move it further in?
>

Yes, I have thought about this. But I was afraid it was too aggressive.

While after a second look, this may make the logic similar with
CONFIG_NO_PAGE_MAPCOUNT. I personally like this one, but it seems not a big
deal.

>diff --git a/mm/rmap.c b/mm/rmap.c
>index 0e9c4041f8687..fb83db88cd1fd 100644
>--- a/mm/rmap.c
>+++ b/mm/rmap.c
>@@ -1753,13 +1753,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>                                /* Raced ahead of another remove and an add? */
>                                if (unlikely(nr < 0))
>                                        nr = 0;
>+                               partially_mapped = nr && nr < nr_pmdmapped;
>                        } else {
>                                /* An add of ENTIRELY_MAPPED raced ahead */
>                                nr = 0;
>                        }
>                }
>-               partially_mapped = nr && nr < nr_pmdmapped;
>                break;
>        default:
>                BUILD_BUG();
>
>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

