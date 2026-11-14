Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6A4606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r9ur2/hA
Received: by kanga.kvack.org (Postfix)
	id 73D806B05B5; Sat, 14 Nov 2026 08:48:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7076B05B6; Sat, 14 Nov 2026 08:48:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590F76B05B7; Sat, 14 Nov 2026 08:48:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF206B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:48:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0FD21603CF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:48:25 +0000 (UTC)
X-FDA: 85433854170.30.48F2DF8
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id B6C6EC0003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:48:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="r9ur2/hA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794664103;
	b=ymGSMFjgAxKa0tLzQB9hm9s4J3BKWBjFaWMpQWS+7elJIJK3fwM5UMTeDbG7PXd393AThb
	R25ipQPvWqOnDzJBIVdNGYpmdcB5HCYUn/ElSqj6BtSSUhbaV1NGgkG/QOp9UcUNRTg1Pn
	a06zIowlV1d9sI6wM+YfZK2fYxJFySc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794664103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTtJShm6kz41I4Yj0S715Z77CNoUEBmcRU05Q30aoJ0=;
	b=rWSVrgGiOjbNjjyWhCwY3b1vU8wxRa/ngVaC+UzwXRpS2nE0TVyrxhSTnwkJ5jH9y/TzRt
	3SUA2j5OjdExHor2YhV5WKmWp8P2IGOtyUtccP4SmixSYKKW53q9W/Eg/fgq6fpS+EDCWw
	HYV5NfF7Dkwrs1X9bqNQHhpmW1l2xvk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="r9ur2/hA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c445c95d553so317876866b.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794664102; x=1795268902; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sTtJShm6kz41I4Yj0S715Z77CNoUEBmcRU05Q30aoJ0=;
        b=r9ur2/hAWBX74swk7njGs29uGGsYBXrpJdQu/sogzUwEsOf3sIun5OajLwEZterTZR
         b1eE0Syzq3AJ+6uwWa5h4BXFfC2FAblQ26HJ+U4OuO0OlTS8r4OC5wkYqmP+MyQZWebe
         U8FDMEQVzYqjgBupJFxLRRyA90UMAbQ38q1W/7HJ+h0B2obpI944H07S1IH+rYQdEH2y
         B9owqjgjuCgq6sQpaj/BrSQBP9YzsuHLWiWFhHqh2vtDWlvrpZjOI56rG20pOQ/fRxDm
         BYUEHflMnEClGcW4xu+r1Zl5ED+XB7BgtV3EvwHd6RGm0t0b/2ErR2Zvc/6YYVFq985S
         B6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794664102; x=1795268902;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sTtJShm6kz41I4Yj0S715Z77CNoUEBmcRU05Q30aoJ0=;
        b=q880gcwuSfu3XhrZJecyYBaHaLuSm/wIhmZmvEzdAp7axFU5tYp7vswshlDOEf7nzH
         HpWpGuHT1oXteDMO8q48uHr4Gd9NznSy8sLdfRKrMawAbxfHNlw+Thz989xdwWLyqlQ0
         WtqDQKwbKZBc2rwqNTGjFX+HzMB2Lu3lYzA29qhNv4md7PCa05Dyz8UOeY1LP1/+YI/H
         V4LubQNOQ8zNnVHGoGZSB5TmmWlF+FSBNBxsHZOjiZ7a8jUCkh931sDU5wf0qwvw8aEE
         RzHRyAiwVUHy2Ipxm0nFvYuldDtuLBKXKMApwI/OxsjkU2bCNrs00am4FVb8XsKAbt7R
         qDAg==
X-Forwarded-Encrypted: i=1; AL+hErHTb+pedqWtvtHEBpRCJI+0kb5+Gtlus6ACGDvZRGGRxq5oKUQbc1HMuxOhBe+fliNv46i0NT5Tww==@kvack.org
X-Gm-Message-State: APuU4Z/Y6IjPMPC+11w6SwdnpOKd14YlYfJbdx0dMa+H1t0HF9S84u7U
	pp1DgviAEJwkn3Oa3422Quc63dPyiXhN34mxhP7qr9NUubMdjD2G+NHJ
X-Gm-Gg: AYBFou1LRcKP6kFO50cL8YR0I7nQXdwcvXnCTvEEzceN0WN/zzRIKZcs2LHGKkArBud
	hX/dVRfiak68qMxrHpMPEbAzphZJqWsmasYPpgFZq8727bQYQl+gbhIhWJFCZJmmMankVOQcKUK
	dIGoVBirW6OGsS2hnzLTbnTBGb0y0S4JDT/x2RBXwu5a1XoCxg8g8PFP6nLr1wbtrj91pmJA0kO
	PnQRzsyY1pzHNo5HO4/oaYo76O/THPFSG3MLDEly+ToSpAcLOnNICSNoEcEm4w4exNJ3nlhVAie
	GUcRJldQOF3ESTPvsRDQtuRPpAF33WAfe+Jv5dvf3YLxNtzqacHm+RpzcowRyAyoyn9QQVXgSB3
	IZmjpP+ejwNnko8HG6f6wkcm1haQbOKGv2Ed7Q2IIYJBk4p7wLnM2kw5HW/GUn21H6UZ7PQATzF
	mplX4RXIkzvWLSqnuLPXH20V13p/ekVNuDMjZythN/YCxuphccnVZf2I4/l9XukWvc+2KlMp87K
	687I/DUj0AkmuBAVeOmH6GsFruqd5c6ZeCw/gYa6T/eIWq4lR2aFlM5u+xAGEJrcKaFcw==
X-Received: by 2002:a17:907:3e06:b0:c50:5186:a429 with SMTP id a640c23a62f3a-c50963c2b24mr502945666b.37.1794664102098;
        Sat, 14 Nov 2026 05:48:22 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c50957c6c1fsm219264066b.0.2026.11.14.05.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 05:48:21 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sat, 14 Nov 2026 14:48:18 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm: kvmalloc: Bail if called with soft or hard IRQs
 disabled
Message-ID: <avhmosPSEJOFCvK_@milan>
References: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
 <auy-7TvVzJ-VCrG4@milan>
 <avcKfEvln8_2a7fJ@gondor.apana.org.au>
 <CAHk-=wg9baZ9EDhZr7ONxjuO65+vvWFo5E2hgxt+3rYo1vnhyA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg9baZ9EDhZr7ONxjuO65+vvWFo5E2hgxt+3rYo1vnhyA@mail.gmail.com>
X-Rspamd-Queue-Id: B6C6EC0003
X-Rspamd-Server: rspam12
X-Stat-Signature: 6qgdh8zqy1cmoqd6au8j1fydub5c8hjy
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794664103-781323
X-HE-Meta: U2FsdGVkX1//A2KpaZpwTaeq86iefxa2htYpaat8916kqbS/aBo9lhC7wVAmWBtL3RZ3ShgLszB2GwUaWzncAFDlOVv3vapVD0KkKF9OHWrdupxoZz97euzVKt2tdyYaMwimST5BxtFNEBq791zbkPjYaLBUrDhvQi/nUDRyq/q8hXlFCiuUcJzNV8OVJWuRp6vfETKpuA22L9HI4glNsyukIm4qoDe2g2r9/jj6sQV0xdS9sR+d5olz3YA3DFHCB3THX3XemILiR8ITsAfqXLV+k/EMjYb+MC+YX464qi26ogIlVZ5nBHTxK5ZZuyhkQLXCcc6PoH4/B4NVYg6qiMnAhHZ+cF/VQ6K3weUvtrmxZ1sM8ZHY9LY2aTdrCYTYZd+QiqbUxiRF1dUKqCUk+na9kyEDusXHxnLI19KeDvMUkg4Odu586wl0/FZ6QYiiD+F14jYfnzBWdnqtzpCT6HEvOVfu5oNEjQ1wg3hhIkDL4fgO2a3WN2EsjUcVfGlpm4t8pXS/Ihq4bUAs2vRnef+2vV2oGVqIbt1oTTA05MaktM+ZnpmZV/3VzKMTAhhM5fzukHu9kLeYM8x5SakGZ3ZMAidI7MvS+0p9ZqOCQ1zp0dDWceQ1RPQ3u/q2Juw3JVMqY/dOSWdmkYb4ljA6fZwFJLWVLyfGbPhJ8Dxov+0qzfRckDO6ajZ7eRwE0CcxS6FQYSq0MQ/MehKkqIG5jl3WTLkVimdOTTl/MgESI+pxw7A1wNdh6JlWz3+tgSAzaXw2/fML6ckuiNIwd3H3RyxDuouO1TK1L4LZfT9H3p7ctpbJuTg3adb95DE9CF/aoNMIykjoZe+Ttaz5JMB8dUqRzA23P+kviNXiYQe5UusTXz8CqnXpz6xOgW6b0fuyZCU8j/oqOPDEa8LQbtX01MTJQHwKKjII3FIamoBpHcS4PoFMPCUGyVoGSvwQdslI626njo7FUnbg8fA3+cR
 V7H1dhkJ
 n5PRmwC4Ex4V7KJqSB9CB2MhvXazYf+842HcF7J0nPaIEu8/GsgKcYNDHobIpNLxB/E6blsY8dVd00hpEGFO4iPEbcRfiR0Qm29TzZeapz03AWBeAF+xqNrLlxbEuQkON3DsGtvTtoq+sVDxPHl5hF9HffdNGaT1IhYQ0BpQg1zilPfntZBEnW5mWy1Do5GRI/3qzERIVsPy0+tKG+yg1DrKAMckspSF0NHiONJE+pGpzs0VrXRmLyoXkuiUdZLauyP8eNeUEAUfIYRi0PEjA6+RHqvDK/CXmSVX5lIMUiZgjGr0QxV3ovVfCMo+ELkFlV5lNjrN5b+Q8/yF2RFyXoL2O1WRgEEbn/MFOYYz9mqUj4RxQoSkJl4PHlmPQqiD3jWfAJ2VSczXKDtKudCY3Sns8CmHxt2/7ci2p2eI588qk8LJ/waRM6lMb0nUHYu4zoANmSBUYszOtO3lCzCGK6vzGa6KoOYlqMjb7/vXy/TV1HJ6UTjQgTZVTfoCnJa8QC5hFuldOejVft8pvtpcFTgGvJMv4sDXijaEa3c8BL6CMQzbXQVxqPchUSFZHurt9HGoS4LUrn0ariSXUjnFDS/iRmcseTVb11QgWUVGRX6nSZ075gwim0E/Kq46eu8s3Izj8dfdohqcNOcsgg4GlfAL8mWO2PIFuynLVRUa65bc1X0SNpuZULkxiPyCk3MPqC97Bb3INLH5hnJETfjM7XPbFBqEGnpvoJr7j6Gec/xDbqtJ2o05iZAG6Oc8L7gH5agyK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 09:47:13AM -0800, Linus Torvalds wrote:
> On Fri, 13 Nov 2026 at 05:03, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > OK let's try this patch:
> 
> I don't think this is wrong, but I do wonder if we should at least
> have *some* way to detect these cases and report them.
> 
> Also, it turns out that in __get_vm_area_node(), we have
> 
>         BUG_ON(in_nmi() || in_hardirq());
> 
> so this call sequence already has a *limited* test for this all. It's
> just that it explicitly allows softirqs, probably because it used that
> bogus BUG_ON() pattern, so it wasn't a debug aid, it was a "the
> machine is dead"
> 
> I wish people would stop using BUG_ON() and friends. They are *only*
> valid for things where "something bad happened, I can't recover".
> 
> That __get_vm_area_node() is not such a case. That function has a
> perfectly well-defined "what to do in case of errors". It already does
> it for lots of other cases: just return NULL.
> 
> So using BUG_ON() is wrong, wrong, WRONG. Commit 04aa71da5f35
> ("mm/vmalloc: do not trigger BUG() on BH disabled context") was simply
> not the correct thing to do.
> 
> The correct thing to do was to replace the buggy sh*t-for-brains
> BUG_ON() with the right sequence:
> 
> -       BUG_ON(in_interrupt());
> +       if (WARN_ON_ONCE(in_interrupt())
> +               return NULL;
> 
I agree with this. The vmalloc() used to BUG_ON() if in_interrupt().
The easiest is to restore the old context restriction and replace
BUG_ON() with WARN_ON_ONCE() followed by returning NULL.

That would not stop machine but would show invalid callers.
If there are no objections i can send a patch.

--
Uladzislau Rezki

