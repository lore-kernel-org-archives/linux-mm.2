Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DDAC5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 01:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7234A6B008A; Tue, 18 Aug 2026 21:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3536B008C; Tue, 18 Aug 2026 21:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574446B0092; Tue, 18 Aug 2026 21:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20DB36B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:30:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81883C03E3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:30:13 +0000 (UTC)
X-FDA: 85116288306.22.62D236B
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 885D21A0006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:30:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=A+hhEWEX;
	spf=pass (imf19.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.53 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787103011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+ygC0wNxl2Z31GJ1PcaOL53f5ivFqBoZjXQriFfAg0=;
	b=S52PWt8CzNdkLkqNB4p/mSQU3H6nCmDUkkz/ROiZWrVcqhIPckAxIbThPKKcviMj3Zmg3T
	44Yq6PXWwhhyObODkg3pvWfEAwxEzsOev770uoHGOxYg153KkpkvPcEJCAc+gMAMweWn+M
	gNXI7ixLlD9DJHjQpCKdIWs/8XH2Q+0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=A+hhEWEX;
	spf=pass (imf19.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.219.53 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787103011;
	b=2eAlucchOH/7CEmcXAvN9amXVAZ2QLvSbcqpqSk1VKEn6zlAJU8gz7jiLYewzN5gng3c1q
	/cYiNgte+EqsFo9hONCHjF6J+Wzt9BMVbRClOhMDcjTwucv4IlEcUrWu2eCgYTS7sGD9WL
	lblAnZ5bgIGtV2BNMLfYNvwz8pJ4Ans=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-9063b380982so6942246d6.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1787103010; x=1787707810; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J+ygC0wNxl2Z31GJ1PcaOL53f5ivFqBoZjXQriFfAg0=;
        b=A+hhEWEXJtPqDcpL5vRtvdRDYrTz905C5jBNWSXQOZt/APoGzw93EYlVJvdH6iZpqH
         VvqKilZwoI7Dw1mI/W8fN98GHbVmtMbvHn4vHSqR6/VMmGgioA1Ynw2OmxFbTD2p7Jmr
         7uxFUFcC/XTMCBYDuGuzg4xZCdtLPfooph/CY1fNq46bJTQ3yI9fRpWKm2w+AQSFlFXU
         TMZRpjAyhvxwKkWkhSU720KGyUrb5IsQS+JTq00Fq3UuBi8BYwcryP+T3IU8PnlbaI3+
         fvv+x6lQCQjgdv0cXGYCSrtxKXwm+l7lGuDumU8DR49/bnmFsMgYQWO2uzA0qweCMVgx
         BNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787103010; x=1787707810;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J+ygC0wNxl2Z31GJ1PcaOL53f5ivFqBoZjXQriFfAg0=;
        b=b14BqxkWUMLmTRST99oeobU6RonviqqZxMWcJT5Z8YekSb93J4ZPrzAOfxC6ad64cC
         2FD9t9kXHcA6DL3R+SCxjsIIC3iSgA9B44m/1KGVkFzKSQb3i6WMS/+yIjMsKSH63QFB
         kd0/12ubGmnlwo/nETzgdKmy6M8kVvCd1/PBRWdoIQgl1u4xQknPHNGQD0uAOo3o/1kY
         aZHr8QubejUMv3rFitoxtCDGDqC9o1B/JKTqbbkvcgFmjhR4TrFR5VEUHg6WzLH8cYlU
         LpPk/Zcz1T1LORkHzG+WtIpaV/0NrEXBnxt20UiAd1fX7+JTy7Ks4X1yfoQu8/zGUG2z
         fuMA==
X-Forwarded-Encrypted: i=1; AHgh+RpfHmHrsGl9SHKrFppTIJiEcah0tfwA2BsQ/qzR7ktkEUp6u0duZNilocr8E63+Qkqr0T1UyJ4LVw==@kvack.org
X-Gm-Message-State: AOJu0YzsV0I9Xg1VQ1qzztY0FlAeFLQaHrk0vjmMs1G/GLjYRARlZYdX
	Ayh2rw5fJRJkhHMkWWG/eGwRDMzM5c2/QjuqaxVzHFT8WxNGxhvP7hkWoIxFhQvJAw==
X-Gm-Gg: AR+sD12K9qpMvfKcHlBLm/1CkSZYpqHHlYnsXHdfk4EKMA6TexVmLfZGWqUfLcAxbv/
	R3LEXHSVh4atrXccjaJ5MxY4A1+M/qch8KixpvGhCyS7EXVqMJ9pBqtjibuYVqiKCnRHV5FXbqh
	grP3Khevuk/IftptJdHL7mgu5WRO/I/qVweBcLwq2MfZsvIdXlT2gMMoqFFGnlsIgwtxT0FzI7a
	mmb7B2Zxr2+4qQKmqM4xLDY6bQlQb7fJ+Nbvq9QlnibCRFsyCZkdFfllPGQBMvqP1jpFiN9HNK6
	j7iBP8mqb4U+2XDiLXmpnKue68zSfcyQguckr1S9NQ82CSIfCJ8vsS3iuPnESwVjd+QEM0o3ldV
	juIMm6ZmQyV/tgCPsa6oSr2zz21U89i2GllAjcc7BfTTSmeYVrS8kHm55vzL8g0/ciAGJikItmy
	xFHVu2dK9AktWSctS3aF0KeA6cRRQILu18rtswNCarvPWonZTyIUpZVDHBPhjamg==
X-Received: by 2002:a05:620a:4048:b0:92e:db54:a2aa with SMTP id af79cd13be357-9371e1f7a69mr163751085a.3.1787103008591;
        Tue, 18 Aug 2026 18:30:08 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::dfd8])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720584d5dsm25685585a.36.2026.08.18.18.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 18:30:07 -0700 (PDT)
Date: Tue, 18 Aug 2026 21:30:04 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <b31f8a14-1488-4405-8196-504e82557ed6@rowland.harvard.edu>
References: <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
 <7deabd9c-04d5-4a45-8b8a-39929c046152@rowland.harvard.edu>
 <A2BA0883-6B5D-4AB1-A7CF-6B9BDF27F439@nvidia.com>
 <2bf01548-723c-465d-8368-247a814f61eb@rowland.harvard.edu>
 <6FC11E12-9428-4975-B135-E24805C2D9BF@nvidia.com>
 <15b086cc-7f10-4766-9b0c-88c3302e7398@rowland.harvard.edu>
 <DKSGX4MUL58E.1QQZGHROS8EPS@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKSGX4MUL58E.1QQZGHROS8EPS@nvidia.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 885D21A0006
X-Stat-Signature: kbpo7774btoksas7f4zy6k5xa8cj6pp8
X-Rspam-User: 
X-HE-Tag: 1787103011-728809
X-HE-Meta: U2FsdGVkX1+Rb79Acd7lE0e9GZ4YAAIevNull0XJJnS07N7b3SnrwPiSBA7D0iWiOZFrQcyIRCJo/f9kHTq7ryGJo/Co06x79vMLYs6SkBZqrtDTj9Kg2iW9O0kJOlAd1hOt9XuUNPEBI6yW7vug09FvIC4wRfhfLW6Ngx0oAbIKgzk9x40U4JjDlIGnDlKTkwNkKLgSYVWxGomWuGYxIx0bXC2zASaDRi2WQcV370ksNUTsLTWLoYxlhD3J4QHoG7Xs5+UmHFCPi011dmp6MpHCsBmb7+71K0Ertq/bBYedXd6Y4DpSFrRQPQ1DZuiaHtbLk7X/x5rPefCyTLt+smcGyk1lKUJ1lYQGu18wos0gGpspQLV6pCdevK53vleNi6f1JoUsOQRv0FgyQekj8zCKg+EJYD/KLIdejBNJQlxU3Uz3zo/LTyi2rau4j3bKlikBwuyNNhGCfACvcAbWy6DXashwbBZ3Xcut11e6kSVXpbpwPjk3LYGG4k/lpvZXtWUDivlzUn4uPwA7J8IqO80pT0uIXwpxLuqcEsztwkzeWfzTQvroovXrjVlUgYlAAv4fo2ynQWIk0lsyujAprRmfCBYUWph6rj3R4PF9jwQ6MNOI5MpLpjypkwzJubX71aVSkfSl0toup09SmD8dgo0A8JS0pY/l6ZM9nQIiuINWP76DaxOYNPRTG6Os3vDZhf9T9LGpG7O+jepwderIEWvjBIvIJGat4SZvGdfwiJCM11txYzjBzXmNVG18i9tYvOS4GquuseIIBtns8tGevCnsmWkn2Zla3oghg4EQuVUEW69KN6fwepTRboFdFB2CGGt/+//wCf57bVSN7pxBF8Q/eBzQcjrFQz1F3JxB0fdlig8rxlGDxSQGUfu92GDBcaMEMZU3H2zggUy+ocpnFVe19nTrqtZ/gPJtJiyYWE5oYvuiFYeRIIIQSUjndyfgC2+tduZGoXc3nU4ZYP7
 p9ymtc2K
 i9HgRrPJOHehYb4mBNHpnly+Tx+yl7nLKOTQJ09yn2KuUFgK0FfNw1ckk2yBVItf97TJosHiaujjfvCY8wGB4O6UfWApWW+yIh9rDn7YK1RLR2nq9sevJZyswrCktZaIAsjUkWMWAoMEvj5LrVnfU0KAr+eRr1I14RrsNdAgXV/grMceFovRuDGwb7jhkY556EYZSubdbAs/to7JdBu5XthkDWzsSk/fW+Xog4N5EVUlZCTfD7LDx6/JolM1Ge5atlFHPXZCNULBgkKz6z6hv47zj2DjUMsNOBAEtKEyiyh/09ay2Pw34SQuVjydgQGXy6INrX6sibplCWl+4016EoXA2DQn0oKSpEsmsbx544hRSCAay8cGvf4GpVFD6fhUEsvFcf2fDFFOUykl79e2piUWYdeyVjl0wuMUaWNHFJZFKc2voKIsw6NxzJc3R8ut4qdpW2tsiBS9dozad60Z+U7hqPeUl+WDPVqRTsly+mOfe09P1LNr+V2IcMlLIjgw3Gmz4S72vV7th9tvp4bkQau+TZ2r4Lu+n9rf8TEEIHtwPJHsQQlBRpbq7r34/yg5VJBgqbBSNy/MNoLqqH3AdnH7Gw0dbQz3UbnbzKdRj7zPLRR/buc9IpR18MzutG3sme/TUoq5goNJ5FE/s1kfFEOEK+j6dwWVcUsqZuUkgjqltPvPoJmDgJZ4f/mGH9DbaLe+8GwHnsQ6JzetfTP2nbFxFoq/vkMbjMBvHQ/Q6907hI5Q56hR/hf+ibz4e7daUJJUWzPwAvOFVabM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 07:45:31PM -0400, Zi Yan wrote:
> On Mon Aug 17, 2026 at 11:12 PM EDT, Alan Stern wrote:
> > This WARN should be conditional on something indicating that the kernel 
> > is meant for testing rather than production (not necessarily 
> > CONFIG_EXPERT but something like it) because it does not indicate that 
> > an operation has failed badly enough to leave the kernel in a 
> > dangerously unstable state.  Rather, it indicates that a programmer has 
> > tried to do something that can't possibly succeed.  The result should 
> > not be dangerous because the caller should always check kmalloc()'s 
> > return value.  If the caller is unable to recover from a memory 
> > allocation failure then it is the caller's responsibility to WARN, not 
> > kmalloc()'s.
> 
> I agree with you that this situation, kmalloc cannot satisfy the
> too-large-to-allocate request, is not fatal and is recoverable since the
> caller handles NULL result. But without the warning, some callers have
> no way to know if they are sending an unexpected/undesirable request
> that might come from a bug in their code. With the patch, kmalloc
> returning NULL means two ambiguous things: 1. the request cannot be
> satisfied due to current memory system condition, e.g., insufficient
> free memory; 2. the request itself is unreasonable/unexpected. It could
> make debugging harder.

That's exactly why the WARN should remain enabled in testing/development 
kernels.  Just not in production kernels.

> > The same is true for all other WARN statements.  If they merely indicate 
> > a programming infelicity and not a dangerous failure then they should 
> > not fire in production kernels.
> 
> It is hard to tell whether a condition is dangerous or not. A caller
> sending a too-large-to-allocate request can come from a miscalculation
> or a wrong user input. It can also come from some data
> corruption/overwrite, clobbering the request size itself.

Certainly.  But the mm subsystem can't tell which of these is the case; 
it _has_ to leave the decision of how to handle the failure up to the 
caller.

Alan Stern

