Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A668FF4959
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 08:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913976B0092; Mon, 30 Mar 2026 04:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4526B0095; Mon, 30 Mar 2026 04:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA476B0096; Mon, 30 Mar 2026 04:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C54D6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:05:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7A5D1A07A1
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:05:48 +0000 (UTC)
X-FDA: 84601995576.15.58B7A5A
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C40540010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:05:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wz6QGvhX;
	spf=pass (imf04.hostedemail.com: domain of 32S7KaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=32S7KaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774857947; a=rsa-sha256;
	cv=none;
	b=6QeibVAfTcgxbLfHc03aSZ+RgmlBA+Q8HwP1dTcEqbo8Qhgf2V0ZUGEzN8Mff+H54QbI62
	FhO7SKBpPSB4L9yIME0e63F54wYDJRUfTMvZ1nJ0Uxdh7ajyklnfrrtNb80/QGpNwE0Hh+
	qnkVDF28OJ/OmXRNCC6JK4HTtc12hUQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774857947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxrbijMaKAuewdVUb4A1KCDJ8qmmr9UD/wuwFSQmNlU=;
	b=dv7dkswkFHHtivCcdKiqL4nROuW2SZwEtFZLG8vunjCd5E++t/GdGBamBqKtZBjzTnq/Mk
	uvRgcw/Gke2efuegHrR2PwyV1Huw0Zq63FX7vtZEs4QReEvT1mNhALcsj9UWNmoWe5iJ9X
	OCinJFqbS5n+iwAL0ILE/RFJYrk8Xkw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Wz6QGvhX;
	spf=pass (imf04.hostedemail.com: domain of 32S7KaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=32S7KaQkKCLQUfcWYlsbfaiiafY.Wigfchor-ggepUWe.ila@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d022974acso466301f8f.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774857945; x=1775462745; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SxrbijMaKAuewdVUb4A1KCDJ8qmmr9UD/wuwFSQmNlU=;
        b=Wz6QGvhXQJq+vR2KvIJyy7SroLANw7kxKpSUrHzGj+6WzU5gkrmKCKOhksP823bOey
         erZ2FfCOk1ldMn5/rVNah8+l97UDGm9QSf6oatckhymSCmHzx7243dQanoCx1Tz3ZR4K
         5NitynOacChMF9iaFLKPYym+gL/dEfv1m33TuDVviOf0SA0Mr8ubx24yM7wZwEARPlTq
         TKVnNe0tlB4TAE/sHjKjUvFThGxU8cISJ2t6S4frbZ+yfz0lk4FJzgQX2+I+KCa/Lt6+
         1HuFwjdmtuTppRgvMbfO9Ek9vs2LNybuDz0cnTsmSQdI64HtmZdn8mPyaPm7DjYNq3Q9
         uEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774857945; x=1775462745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SxrbijMaKAuewdVUb4A1KCDJ8qmmr9UD/wuwFSQmNlU=;
        b=QR+ea3iYpXyIl4gFTYrcQcYv4zfRyZsEDO4HvraXjN6rsxORlYE9GAhVnmXgxvRgYF
         FVTqusya0dDphE6pMArED37kz2NVP4GdXwE4NsmatZddJw23SvSglJ4Lv5USA/fKOPN0
         f1BRwIxalvGrDalOzGx3CYbyXhe05woz3fHbtzKtASEUtRRPJSdQc0ZAXkGwO5xmER5f
         B3D83HKhYUadN5LgP9Oi/hdgsU+c5XTwRD/Q5pGaK1UmNsg4K7Esu3yUmQbKGcUxWhCJ
         P6K1NNn1r05zSBGL+Xf5r4alft0ANApRPe0JIXHYfFBBqAaVglrBPABUgiIOFzfyPWCP
         4mbg==
X-Forwarded-Encrypted: i=1; AJvYcCWUGMV7+XB3tAbRrkddnsyJNtx/BXKXlmWNUTIJ+iWj4alRGTu6hyozkPdyyqgXMzm5FCmV1C+sxg==@kvack.org
X-Gm-Message-State: AOJu0YzVliPp3e9PxQN1xbmcP7Z1VL566KTlBK9Xy/LKRpMzkFE7Pj6N
	wLaupUKMh6A48Zh7EEQaGEyiwTAmM9LNLqfZpxLrS9/0OxwRSROCP7zOTnbXAY8szdYPPyM4/6z
	cwi/ef+ZHQygQoXqP+Q==
X-Received: from wmby6.prod.google.com ([2002:a05:600c:c046:b0:485:3a2f:2f7e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:810b:b0:487:219e:41c with SMTP id 5b1f17b1804b1-48727f36da5mr169791385e9.28.1774857945322;
 Mon, 30 Mar 2026 01:05:45 -0700 (PDT)
Date: Mon, 30 Mar 2026 08:05:44 +0000
In-Reply-To: <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
Mime-Version: 1.0
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in> <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
Message-ID: <acou2CsZOUQPx5nW@google.com>
Subject: Re: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shivamkalra98@zohomail.in, 
	Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C40540010
X-Stat-Signature: j6k66d1pkdkkyaah6g5cg9qzdsqczy8w
X-HE-Tag: 1774857946-945500
X-HE-Meta: U2FsdGVkX1+pJ3bDkhlKw2RHqAGh/S8Og87woxxvTSGtjfybBqyg/y6AU3mHHoiR/6illO5rBBdP5i/wjy1hmDwg3WTMFMr6UjeNgrb4CRwxtv8ht+5sZfvegiup8HKjFfcNMzvypCGzpQ1FFRSeaWjCY9IHbe7b/0zB9mr54BDpsn2spcpyhthB+bohxoYN4S6QObYk3z02I/MCicxPrfnPLlLIUhLsYOERW01iS/vyuiN/L0I5ehkmBeNp92b1arlncTxIKse2tyiemkCU090MEUrX46VAYQAxwcktZIlEcJBX6EwD5kNntALReDqyqg1s0eYYjJPD06zUu+w1Nt4XKygs9d9LsWkcUNu05wMdRUNaWm97j3VtqHjl/P0xTOwtEizQZLTVER9HiiUuvBzgU6Z7VPxtTzx4rQZwjYc3Mj20g4Q3XTux6S7eFlrlX3trsdBevSuwIBROBSMn9z8ZdqhgnpnWODGRE2Th+8cdIxbHMx2yITBCdnMx0vUovnMGBqmHgVQ3JRtwPiUP13jHWrXxRslnk7YSX/oUwLEUF+qPBRaavs+2Pph2LCtMb8wjwC71XLCNNZSB8dahR/pOXKxZTwpKeUZYJ+/7qyMGTMifXJJB1+Kcon9a1NM1m6HEoqr0nlOfblMdLd1bQUc1E/6QGyK2mocvb+2C/wFTaNGDdPhI8yu0SMfxo7s2VeP7aXdOmxxZ+VxYJ3fcpfqB9Kiys3MQNj/DFvRPZpkkGrQnUlG9SPO/VojoziU10fsVeXGfi+jSfF0Dk/5UbA98uI+UnO8HvTZ6r4K2wSriDxS0dC/KdJL8VynrfoMFjl+5xAsAbjXxNkkN5wzdMvyRD8mSV14LBiRRRrg+X+2ajLQMn2dT6X2KJoTLI06STDbGSa0s5zkAO59KEcGME/6P4a6IE31SDwbNB1sMXkPRw5I5eX6r8sAp+vZ/aGzq2n+6h4XXgEJ5V5KVkV6
 MTNJbgwb
 AHnlmikLUhp6MIuItSFPkoaFji9RP/evpVPu0ThFT76vpTS8DTFpJYhm6PzzQ1+20QNE49+r8Wfr7bZxc5dbZa3ysDRPg8xx9jEGtZAf+/m5wy4VlydWgi/mLQsfe++fZay0Ywyzcbug/1Bkx4ErbAuQ1Y63G/EFy3LR6B+Iiew47FtmqCi70KexzBApBeZXTkK1WFvLIcDl5JpCQWYQqz8VeO6BNnAfRt8KJPRqnUpIeEarn08WfX534KDl2RyFx9ara8KBiEuZlTN/o4rzSwO+WJuWnWgxtqd+X2i7u6z4mLRDOVVr2ZsLPaB8urFAykz5H5C+/7nh581J2I7iEQoBqddK4cwIST5EzQeWGcz8HETyU+GW43vFYTYAV4omZ6RSFMmMSi8YcAovT4544zfjwnKLEQXxhZmjaN7MxdKZeuMvDNLIIbVipIPQAosa0+xxxIOag7dRObeMyXKekKN3rQkSrKkJ2kbj3eafpjXs0uOr4kOY0W0lWrS9oBRWhqX/GeZjbyHg6EusV77R19uqgwBZykBof5PNZhY3dqSb1tvSazeKqw4VexVXxvItEfZXF6xlE5wHqZ/XzEWdAyj+k8prGc8hbETiPPeILL23A4xJNcTTlXoTQ+O4PTRJs1LjytUJpt9DKMpDwURdIHa0gKlYyfGsi5tSTXZG1nfHk5kvun8fejqSQI2n9B+qG99ZemcI/F+R4GTnW4S85DxFJjGS4Lt4rJhzwa0zEy3gASYP7J3t/rhenXQ9Zd0jI+cp303ST8JDKL3bsy8g2KKAIvaAYiPx/mJLXbkH5AOhd4cG2CpqxLnNafQzsfVgtEikpOFzPdU+Ml35Wgu9MR4gKIXm5+QDN2b/Glmh+OMUdOXuU/lRHNRr+9WNrHkUw2Mnt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:37:58AM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2026 15:18:36 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
> 
> > This series implements the TODO in vrealloc() to unmap and free unused
> > pages when shrinking across a page boundary.
> 
> Thanks.  I'd prefer to defer this until the next -rc cycle
> (https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org).
> If Ulad would prefer that we push ahead then OK.

That's fine. No rush from my side.

> Are we able to describe how much memory this change might save under
> various scenarios?  If the savings are impressively large then that
> would get attention.

The primary purpose of this is to ensure that this scenario is not
possible:

* There is a global list in the Binder driver. It's an array allocated
  using kvmalloc and resized on demand using kvrealloc.
* A process decides to add a bajillion elements to that global list.
* The process exits, taking its entries with it.
* The global list now remains extremely large for no good reason.

I don't know if it would save a significant amount of memory for
well-behaved programs.

Alice

