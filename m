Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C90606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eJWaS5zb
Received: by kanga.kvack.org (Postfix)
	id 5163F6B00EF; Wed, 11 Nov 2026 06:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7B06B05B0; Wed, 11 Nov 2026 06:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DDAB6B05B2; Wed, 11 Nov 2026 06:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2526A6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:51:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFB7E16014F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:50:59 +0000 (UTC)
X-FDA: 85422671838.26.E25305D
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id C245A40008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:50:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eJWaS5zb;
	spf=pass (imf01.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRH6MUKav0M16elL+r1RNi0TrTCbg0d2/wobD3LW384=;
	b=7T2zQ6/SOtn0pJcS2IX4mFRShSJNY+0ZphhKOBCyootOr2ZxlfiEMSN3cP0V3Ck/C6NURT
	8j9EZCXcnezGjT0yLl7eg6uB8FFEJqS09+nC4OCT8JYnGnM5XMsYEPGWQTVHdpBmChakI5
	3dhwUALOWrarO+6ea5meL+wTFI/mPiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397857;
	b=4tUmYn0OTt5iEwVzaBIYmklk65vZ963bIOB4a53nwBzGWlhGdKPcs4ciynQwMKjNx6OXN5
	NqA0TadkydoballohnM2RdnB3oofJIhqCM3ZSbDOYmDk39XZPz4IXb7dZQz9xzFqfKuaAY
	fMPI/9NUhNCcy24BNe64T0+8tX1jwL4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eJWaS5zb;
	spf=pass (imf01.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36ecc11bd26so56152eec.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794397856; x=1795002656; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WRH6MUKav0M16elL+r1RNi0TrTCbg0d2/wobD3LW384=;
        b=eJWaS5zbNBMjF7t295IterKoTOSemzTTveq4zO35QYgoHWOpXoJYAe+6l685fY1X0Z
         eJQc8ibNaTkImmk7ipne9i6ePWAL1PW87NF9s0FoDOiWMTVnXxNSg+EF2DyUFcdwHA4G
         0Rc/7CFyVjci5uy5raAF1cMzZp6X2FFto0xK9uIG1Ih/QsLCOaeWOfWFe67pEHqgpq2l
         ZFmpA4bhosZAOlF2VuY8PCx+6N9JBuOPOE3o138AhslfU4vqm5vw+phRAA9OwnZbLXJ0
         mrbNOG8UXB/urV0iHRFcyNhQ8hcJvFf6Z+0JDfHToRwgtyFSDztpwPy/FBgLZyCINAdg
         S2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794397856; x=1795002656;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WRH6MUKav0M16elL+r1RNi0TrTCbg0d2/wobD3LW384=;
        b=XpRmTcvjcaPdjTWS8928yTOyHX2ICyG6pqXySqUtOtjl2XHsiqTwv2v3Vwuv1ndQNi
         IfRCR0iZSK/OWTqH5wz72Yxc2zjNjbIAU5xZaW4oC9rcw+rKmrELttkURWnM3DKAt+Gb
         rkDoLjzzNm6SclIO3GkUi2C1TetAJE+hggGg58Vw7yw08UABhd7WhdDSQZb16afSHUML
         hKykU+a36lXSF4S7u3PDjsblS5HZDLgSlxllij4z9qcnNoadLT72py70swT0RSs+VYbp
         MD3VcsWtD6mmzE7YKpra1I+X1lp+iUnVaLFU8sa9uRfy9WtZg+OOYPxNkkSUny6HazsV
         Scug==
X-Forwarded-Encrypted: i=1; AL+hErH2prAGQHnLAM6IgO8oM+JXHZ1BW8tfv0LrgPghb2qUt1P34XvyV/Zu951cUpkhma1dzdnNSd+Rug==@kvack.org
X-Gm-Message-State: APuU4Z8H7KQ3ZEby5oU07+M0yv63Mq2ZoPJ0bhPe0GzKoVuNGr+W965f
	bkE3FsjMkDgg8nv1tY0cdCsUemt0xuO/O4JGolyyHvSnlPxB0sJy5z1zdmQahLhZCtM=
X-Gm-Gg: AYBFou09vcX+u6VUz99UDcvdxNV89njyV2Rs8xM/ozu2CtffQHkvfZI1jrfhM3KOzxZ
	LeERyE+10ig6SiIQCdd9NXk5OyjVYddpLWHtp4wG4xOnrO+FnLw9zxG080Np7GVSjSYMJrNW6gp
	pyZsueSnoAW2a5wGasNuHBMmeRnrBiLzMURh6e//iXxEunygTfLkzJmI44L7qUbaLLTMPqZnIb2
	WyTXvgi+W1DeGTldgYbPhIuLjQ7dYXlZ/bV+OMIDVlZgEoQbXbqRhGXjUtVZTbHRE0MSqF5hO6U
	wdtw8L7QHWG8Vl+mlpJVMvcu/RV025dmAyR5YIEXDoyRwUKrWVit/i2VzkFa1eLWR0IbM36TH9W
	LXXqfX/pgTm3qBz6c7P4VjyR1gs/bDPKkMbBX1svCT/A2cHXEA2q1uJ3CLA8zWWeEcXPfC7duFT
	DC4UzxzgA/OrKx2yJ/DfyUxJTkbDIkpFNQapF+FYWMswF32n3rax0Xo03ZCxwh116wocFwtBLsb
	VDuvWHA7F3ABrM4rBHFrqXAwKswuWqy6y2PakQTMJyzDrdyJH24Auduu/kkdAk1nMPz+EcXPNGX
	/tWbmjLvZYdEBMEqRCLjxBIVYUo8s+KVkdZgh/O9vrkRmYBrro8U4w1vMzMBZGkKbX0=
X-Received: by 2002:a05:7300:7f01:b0:36c:a1bc:6114 with SMTP id 5a478bee46e88-3768076e52bmr4229530eec.0.1794397856119;
        Wed, 11 Nov 2026 03:50:56 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe29fsm17427609eec.21.2026.11.11.03.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:50:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 3/3] docs: zsmalloc: describe statistics with
 CONFIG_DEBUG_FS
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <avQJ5NG99xSRhAwV@google.com>
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com>
 <20261109-zsmalloc_stat-v2-3-caee41684aba@gmail.com>
 <avQJ5NG99xSRhAwV@google.com>
Date: Wed, 11 Nov 2026 19:50:51 +0800
Message-Id: <179439785114.2142163.1777880997906503143.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8nmem36wpzodxi5kqsqe7tew5wkwpkmd
X-Rspamd-Queue-Id: C245A40008
X-Rspam-User: 
X-HE-Tag: 1794397857-935819
X-HE-Meta: U2FsdGVkX19EExmgWQSRSAsep4FOnDgiyCcNGLHr7yQ/67pw6bmp2T0KNbHn2+R/t6YYa6cNKEdpwbOoeIN3n6ul+UkRTekBOM4hZeMlUmiXFBqej1ik1kD9m5TQ25OLf5GFgTNswCHHvtEqLUqYHyvT12Jf+s8Sy1sBNe8FgLp3aBkhZBXu6KXQcLbw8DdepQjwy3eW78B11L91d4Lx4nLhzdujxmfWx/ABfGsr2Ef1fdVPptrn9rVcRAr4q/RSZ1+a9lvL57kC83tYaaWDo5eylNAv70QB6cFylM3ncmY8RrJmxT9JF5c6WdZG7QL3Sz7gaRFROIoFR6+QLtt0Lt/9lyZjsP+BvH0J2kZLHAP4AaWk63KwHU+gCQoiIq4uhSkX0DxnV9q5t7vtTPMyhBEgmpT/J957oI9oRjuAEcX6a0mRPS7hL1sE8ie5E/I6lYG+YnqKSV13b+aI0pgsOlAQVgZaH11cUfmmhFrtXRIJFBLRMhKSis186awb0qUWQ++bK0GRW+XtjKD24UyL9rTd3yk0ojveS0q7M2cI2WSpzScqBV1Ug3yfnzwWFWO+/G8TusGOCLo5nRlWFTFKHdX2XRzD2ulWNzDsAKfHMeSpeoju21spkc78W53u4hF6/R8rUFVWEk/nUhw9bKeQ4ped9WjQh47qqyu4A2DObvFlUnF/tA2YTp2oWdatD7Y34FyCixR28mhTcKlTVCNSJBcqvqDojgamQOpZnxUIg5NhXvQYCGUEOiUyiEg/zuSaYU5k5wMPR1OWn1K3OKE8AWkpmuTHl9arJ9qssFbb4Xm5cox9W+IWpC/qHYXfwiJ1rvZZBs2iiSrl2UJecuwV4GJf2uNCverGjT3giUstFXs9Nh2PQ3Gz1iwaN1R/5FwVTM+dxLPEygseoJOEAX/NjU+ACwlZbtquINYggh+Yq8Pkl4VBVqRDC/KUlqHlwzt7E9eY1D1pxRmicTeSPmG
 NuxCERfi
 0XMIzwGYb8N2bmpguIZiCb5HgI79JAfxl1lcA4uhxOWTH+yMSVDsaKsY9rh38l6TdliYyYNFFSC6hSCN3mFGEBz9XZEU2fz8Y4TMyR7AN9jFLYZHVErlmFnDWIz/fbt+YLsJeiAwvXqRtL8j5V9lwFTKhnUcz0+r5BGeYK71Bl4zvSC6yMVDwcr6SQbAYZl2tV9gqYDKQJQq6v2Os/Ic37JgAaag57/krI08Wb4YAS+JZcjQR15cIJknDl4+Ck7g8S9qo2pvcjM9/eBjC0n7+tv7LCEeXb4WgLAsaDPYIHxitGti9K46UY2QrzGskTEtEzUG2t77I1eUn7ySXfucVgrjmAf4f4XLbBwcaa07Jfr8l+U83BvrI1JF7LmhzLnW4O1pPW0m2r1i/1joXDxf8++VVnUF6KO1b9KxzZfv26J5teGRDRHMoT0LbW1CrLHlV+FecuAKzM1KDv2IOgyGDslPMajW87scJhie3TslwtNxkYB6crLhl1SNL3boedk+cMgc2y8WLApqpHSeHm6SnC5x53uvminyEL2iIWhSBapq5QhLoVXZdxg/vUG2sQMtCmGx3T1DFKKGg2jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 15:25 +0900, Sergey Senozhatsky wrote:
> On (26/11/09 20:59), Xueyuan Chen wrote:
> > -通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
> > +通过CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
> >  看到zsmalloc内部信息。下面是一个统计输出的例子。::
> 
> Just out of curiosity, what does <user name> mean?  The stats are at
> /sys/kernel/debug/zsmalloc/zramN/classes, where N is zram device number.
> 
> 
I guess "user" refers to a zsmalloc user, like zram.
But yeah, <pool-name> is clearer. I'll fix it in v3.


