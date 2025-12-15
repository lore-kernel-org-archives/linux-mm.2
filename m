Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D885CD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 04:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1CA6B0007; Sun, 14 Dec 2025 23:12:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE1F6B0008; Sun, 14 Dec 2025 23:12:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF456B000A; Sun, 14 Dec 2025 23:12:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6A86B0007
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:12:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2526BE3A4
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:12:54 +0000 (UTC)
X-FDA: 84220384668.14.6ADF2DE
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 188E5180007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:12:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m9e3V86Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765771973; a=rsa-sha256;
	cv=none;
	b=al/CnSe2Bf7G3AAsW3TR/mBtsN74mlVxwvmHQyHv4Tno4PZoZg8JJa0iKk4Zr56cNG0QtE
	2W2a0nvWjbgstRrLMpgi2exKZDRF5C52kUrZ8Q3BF7lukDXAAHk3fl0e/NQFrIa15x+C0F
	sBvC92PAqEAjBG+ScBzvgpxRirxiyhE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m9e3V86Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765771973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7WdVlF1ZVFOwg9cCQ2+YP4yAALFQOj5B79ExwQ8GjA=;
	b=K6X5prHfU/75FHfao3FEeDgDcXTkdFYYaE1zX61lulzsMGHz3CzKeUfjptA2HP+SDrtSYz
	1JnAGduru0M1XfTrEF1SQmO2WaFhDGhHLDFvtevhM4wJ9J2aNfvVUYjj0vZtqLydXbZRPQ
	WCMDUWXawjl9gDe8bHz/lwhlSrhBGBc=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b735b89501fso389923466b.0
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765771971; x=1766376771; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7WdVlF1ZVFOwg9cCQ2+YP4yAALFQOj5B79ExwQ8GjA=;
        b=m9e3V86ZOz6Cr95r5lU29NfkYtpm6nj9DRHVuqSxqB77YB/EdmLH1H/ZZXT1VmLShI
         ltX2CiPgVUuFP1FyiozNO/v3fEBUgQDtjbWbtZt8WxAkFOwfAZoa/GA+gZpTHbM0uPTV
         L0fqpIYoveuoWr+5/w5cWahBWvD1/ONga1uU5w0V51ElBgjmhVqSxZ0JUuQt7jO4xiwu
         OxYF/bqRpGkFzjUUcgm9d9V6CB1mJi8KHZZ6KeA0KSMqUqvy4lJG2ou2aFOYuZF4gb3d
         z7YhWpGsC067ycq6Q+11ALJTPMniMDSPyJ6oT30jR9iAn9ofNG/uJe0A0WQK98vWW+a3
         GOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765771971; x=1766376771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s7WdVlF1ZVFOwg9cCQ2+YP4yAALFQOj5B79ExwQ8GjA=;
        b=TR9SY1RQX1Mk4Gs6+dHXg4d4QL34ccomeiqScdgyZyCHU9RLh2xgKCLAw6TX4IU3rO
         G8ZUIaFFOlbIDV/ezL6AFkSVdsV6b08F+4fcu70Ey5gosY/YzXmBtT+el3AKHlKL2VR0
         PwIkTavv8Lv9X40vk/6jTZsGwWLVw7YfcC0oWLDLP3QuXhL2VJM3nydbm85G1rggLZ6I
         kd1cXYf47uME2RG/cCiViyFithHWjEImjLiRvtmdaJyXaZnYxOnbk+icGPx4Wfp9KdNV
         KMcz9ZZJAtehpQLBRhkjubhjd9WIcyFqLSk8dmvMPUdBVk+wEQSD33EK8YMoECAyN3Ci
         9b7A==
X-Gm-Message-State: AOJu0Yx6Ha1FSWBKt3H/XArL3+A727zYQjYVSGRHEbSbdrUaNzAkh7CA
	d4syCkGjoXOg/InGpbzhXTqzE69+e5q3a9PIb5eE36f5Tqhv5X4oTJcxRze4V2CI1Md4HI/Mteo
	YsvJJhZBBFba58z3mWHfWivgxZ593S7a7QLEnc2Xqkw==
X-Gm-Gg: AY/fxX7QU0WXakOn+hPhwvw5/AZg92RXACIO1YfXxXW61v9KkcugY4UfEIa+bCsqGaH
	M8nuL/6oCaTXNCTtMV/1MnTyKXIHoiGQqQCe/9b1ji+hiJZOFip2t5nR3z+FxW78CaWO7lsKjEt
	Qyfg+hvjFC4w8ZaP1UwiXkwLdc4ct5ceDOS62biPmabqbGkCEA69RBG99e/phg0/PbtY+hvegr4
	cfbldqQDaJaKUxnWgc65rYZXU7KlGsB/MZyWl4skJSUrI85pap5d2IyXniIHmnJ+/Plp6lDibBJ
	jfa/elqGh3fFCXIjIpsR+lKyaDk=
X-Google-Smtp-Source: AGHT+IG2CeiHq0HnMsR8Vfj+3Xdj4DT4nztKsKt+2soyCOdcnCiwaVEpuuofvJAACD2x3uUE7APgLoINQ6i45emUfDQ=
X-Received: by 2002:a17:907:60cf:b0:b79:eaf6:8f5e with SMTP id
 a640c23a62f3a-b7d236292b0mr1006900066b.14.1765771971262; Sun, 14 Dec 2025
 20:12:51 -0800 (PST)
MIME-Version: 1.0
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-9-cb7e28a26a40@tencent.com> <aT+HLZJRgmvca7K2@MiWiFi-R3L-srv>
In-Reply-To: <aT+HLZJRgmvca7K2@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 15 Dec 2025 12:12:14 +0800
X-Gm-Features: AQt7F2qdSzeavrnOms-TDSitSuzsfFV7sgavHev6GiOykV1KOzRp56FOQ-Lfe2k
Message-ID: <CAMgjq7BQ_5g25B==sG4nLJakvyT-bBbUtueZ9wtx5KUV-G1naA@mail.gmail.com>
Subject: Re: [PATCH v4 09/19] mm, swap: swap entry of a bad slot should not be
 considered as swapped out
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 188E5180007
X-Stat-Signature: qa5zmwr4w86w45snu4541tu797iz59ti
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765771972-763797
X-HE-Meta: U2FsdGVkX19TIZGQ5gqflvJcVUCa3quLWRfkYzL2X24lOhrX9X+RDDmy7elGHm5uKq/SbZGEVxDjhFGnt++CSDbVPy6uCVT/0viCgQy9I59oH6jHctXNrm7SWrIse8Zg3luqZpW2plvvXyny7FzbXO+Mlg3zdKKcDdQIz5KmKANUcRnRXdhGzyn3Tpbl2BcmcqRYAOI3H2OZzi7jT+VyNgYmFArLUfGCs2VWs+abqTZbLAF9k085ZeSiuOx7XV/MUg/waX4lizSVt+2agvNF+KLFR2rIlQOgAx603LHq3hJg7aHu9iOhBHCjfzxgD5sEqdmBIp8VIOkj8WwaccuJug7LhAnH3cP0YRsZyl0RCUYRvVRYqsG+H9q9zgf8BGp5si3yZ29uM1f6jVHViN/D583QxMnN005r3jJe5+VfrSI0uO2RMYMUZ+so/U5Ahn0l4wqPSPkkDp0UiwcPXmosD2I+ckG3c9O9v/ZBQNyS4J/kyUE9kXjV/kjWhnOZpq1HGLaEbXrDla5GJip2IRNDyfC/Ogi06vUlQ9/1J+1VXJ+3pMhC0JvQiB8YZUSoKjnUZoRIdL+leR9JNji0cpP1DxFtPesavnJ5jrcbDEyjyCgGJdpa7Fb0wi5WRYk71QHFxKvOgvVDToxvKz7k9C93PxROVmuEziyctHUBBnGYRjCuSdido3EDrS4KK98RVK+kvXu3fGjMRooZkI8qfHCaxqydAOHar5dizozWZuCvGv8P0taeh7fWEbus8TCXbxBQtB++1dLPHOIFQKS+dSJUBylXFQpXKzIPNJUb/xqYgE0VspOxbkcZ75E9VSY6bcuyEh3JI+SpJ05XWTEUSXVbI8xbt1OrO0DvikSeDOUDXmqcN50yc6nurBfz5P+NNfL2w4Dhoud5bVCoAPP5JkvGtrjyOOliI9vMt0L/c4jqaewLGydCOJk+JJtNe7mcBVQiqk01JEKYD/m7Egkqoq7
 d8GHpl+j
 nV4VeZqjZYLhlw8iLWtHXKunghBxHnD9I6ynPX/hzpvqNgLKmwiFlPW0qnnXk3OhSar8beRXsPa5ShDSKhkGaunLHXlDL3jjrfAR4l+gGAE3DHlXI9aXDeoswQWBmaGiIhEAtMQmcer484ysREBqDdXbRa8iyUyFup6ref1q23iUfKi75WfhMO/S1fjLKwiuOg8vRAocng2JNjVNyD68M3nQ545th8ioR1loBSeMqDN4vKGgsEMrstprjrlPaZNV0RBzb/gGkyLMn+FHODdtWFtNGVol+n6SBbsrVnVq/ZqN3CdOAsRuKHBYifdbLlE0d19PfkCqTdOH7VgKBe3NqlOVcDoVDYNofxnu+C9rYhWMdjV4qOe9Weh5jtGg7rGYcxq8ENbvNEGh4oquOo+nlLtRfwJboVzEg8985SGtyC7GOB5TTYGLE80xbJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 11:57=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/05/25 at 03:29am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > When checking if a swap entry is swapped out, we simply check if the
> > bitwise result of the count value is larger than 0. But SWAP_MAP_BAD
> > will also be considered as a swao count value larger than 0.
> >
> > SWAP_MAP_BAD being considered as a count value larger than 0 is useful
> > for the swap allocator: they will be seen as a used slot, so the
> > allocator will skip them. But for the swapped out check, this
> > isn't correct.
> >
> > There is currently no observable issue. The swapped out check is only
> > useful for readahead and folio swapped-out status check. For readahead,
> > the swap cache layer will abort upon checking and updating the swap map=
.
> > For the folio swapped out status check, the swap allocator will never
> > allocate an entry of bad slots to folio, so that part is fine too. The
> > worst that could happen now is redundant allocation/freeing of folios
> > and waste CPU time.
> >
> > This also makes it easier to get rid of swap map checking and update
> > during folio insertion in the swap cache layer.
>
> Will swap_entry_swapped() be called in other places in phase 3 of swap
> table?

This function might get less called or even removed in the future.
When the swap table is fully ready, checking the table directly is
cheaper and simpler. I checked my local phase 3 code and there is only
one caller left now.

>
> I checked the code of the current phase 2, in all three places you
> convert it with swp_offset(entry), is it necessary? Why don't you keep
> the swap_entry_swapped(si, entry)? Surely, this is trivial.

Right, might be a good idea to just keep it as it is to make the
review easier. I thought the `entry` is a little bit redundant with
the si parameter, the type info in it is not needed at all, so using
offset instead may save a few CPU cycles while at it. Really trivial
indeed, I can change it back if there is another update of the series.

Anyway, thanks for the review.

