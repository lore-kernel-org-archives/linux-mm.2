Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0B3606A334
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=S6UPL3Lu
Received: by kanga.kvack.org (Postfix)
	id 8B6FC6B00EF; Wed, 28 Oct 2026 14:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867A76B05BC; Wed, 28 Oct 2026 14:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7566D6B05BD; Wed, 28 Oct 2026 14:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFCB6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:54:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D235D140226
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:54:32 +0000 (UTC)
X-FDA: 85372935984.24.FE24C57
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 68C108000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:54:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S6UPL3Lu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vc/BwRMumh6GCDfZk9HEhgcPOmsWkZc9E+U0h5Wqek=;
	b=53ZUkBvT+waQyCNIUlJLAblWAUU/of5eR7CHEtNlX4CzWTkYLKHYhPp/odsPNehv69NcEU
	MnmXkp51ybjJrSR6K76zoQI7+BHoLR0wZQd+F/WYCOl9lCg6UJEphENcqvVoZACYILSnsf
	O+XO1l/z4IW+ZyyJ27sDpG0+Oh9JKlA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S6UPL3Lu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213670;
	b=dusJjidhgHINQdYq7qLUiXbemJMTdMhJlaDNtbaWiJL/yOqY7l+9+s0yUbhYpGjIF0YFbS
	uUmU2jE+jM944/i3xRFZQsesXlUTW75hO4+0DcVJ2y7CC8R1JdcyGG8zB8miFV0TjAKmm9
	h6I8w2FizTy/pkkJZlGDooYd2fw6o9c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793213669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0vc/BwRMumh6GCDfZk9HEhgcPOmsWkZc9E+U0h5Wqek=;
	b=S6UPL3LuEu3t4EP+SqZsdOo3Pvkl0B6g2qFejBlIJUviQ/xF46QtqLiXZOEaMcknm8SSZ2
	Yn9WB/zFQRiZO32+5GgxOvtqT4BIgd3INuM8tiPcg9+F4vLN9FS6D/TyZlp5exbqUndJ9s
	gvcf8oGoZvkCw+mCjARc7irlZEq9zYY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-ZiyeGxYiN-W-EVoGNIcw1Q-1; Wed, 28 Oct 2026 14:54:28 -0400
X-MC-Unique: ZiyeGxYiN-W-EVoGNIcw1Q-1
X-Mimecast-MFC-AGG-ID: ZiyeGxYiN-W-EVoGNIcw1Q_1793213667
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1fa972b4fso6611035e9.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213667; x=1793818467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0vc/BwRMumh6GCDfZk9HEhgcPOmsWkZc9E+U0h5Wqek=;
        b=jlVGMgCALiqIEU+fn68UoUHPGQatPM7SiE6gyTw5DlUHlL4AvP2qxSdcnBwAftECzt
         QKB1jOl6ftsYFdWgI3ZQ5P+G/pOEh78MrcTu/7EekRyWw8z2Rbf4Hg6BDEHGENKDClke
         cqafZC22sic78w+MLHAaSTHZE8QEVQh7Ezgj1d9oJ8fjoDRkUJcuLfuqV5VfigyCz1Qz
         LD2xpjaLtJKMLJ7rLj69TMNw5ogcZKMNkitQz8g7Uu4hK6GKTZHVWRkKtQlq+67GrDJ3
         YhdkSSNPaIcc5wmxiBQSGLw6KMFUN3GdFFdIlIiNRc2jbkpeubS/KN9INy/9Jgs8sg0S
         zzqQ==
X-Forwarded-Encrypted: i=1; AKwUvByF3DAFpxdGyRUG5EJyzSCrVGbA5ln2HP2F2qvaoZyJXkr4FQ4TgM/y0ISqeXbBM/y5Yrh13DAHww==@kvack.org
X-Gm-Message-State: AFq9FYIR5om3lfykIuVWSDeYufQRokOj82ls4txInRCFmlhTBCyIX/rg
	m39h6/fgO0YusSZ7U6YHtugQhVwKUHzJ24pkJoDno3j3dVvu8p7QfNOXNqbWQLqFBUuX49hj3uq
	uNDMz+GcY0jUmfBwa49WMj7jS4R1R7RDcVa9IvlM90fV9ZbTy23NR
X-Gm-Gg: AYBFou3rGx/QtqEHNZxqTNG+AOJ8Xl8eTITDvmlBrjfXQ1Y42JS/KSztR8009udJPdH
	gyg99KE2NUbJjiUOQxRpbCJJYAVWp49bsTx9ewG8A40j80WVFY1gIa7Zrih/oWvWAWxSd6mfAnP
	bZvhEOi1AZGHK1erwXbeayCRdeDJWKb4ZkeyJybpjjGMJN4izENQwj8noaskhrn+I9XbQJ+WWjY
	rLQA/ByO2h/eVAcpbOj6kWpRpsgtL8fu4ZRk807I+hFa9Jv5S7kPL/yXtzKNIvXFucr/1aMQhDo
	U/CF2er7TCbdSohHGNCPHkkaznxPt7dWn8qYJgtsaoI2j4b6LN3EfQHX2+VIqLC2Z3gkiYQymtP
	hy5a5eTlNTOp0P/hgb/XfidSvCiw7ENKzJ5CSBClY
X-Received: by 2002:a05:600c:524a:b0:4a1:efba:511 with SMTP id 5b1f17b1804b1-4a9674e6bf7mr73578885e9.35.1793213667456;
        Wed, 28 Oct 2026 11:54:27 -0700 (PDT)
X-Received: by 2002:a05:600c:524a:b0:4a1:efba:511 with SMTP id 5b1f17b1804b1-4a9674e6bf7mr73577935e9.35.1793213666877;
        Wed, 28 Oct 2026 11:54:26 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04785sm10398775e9.4.2026.10.28.11.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 11:54:26 -0700 (PDT)
Date: Wed, 28 Oct 2026 14:54:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
Message-ID: <20261028145316-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <279a92da-772c-422b-8047-ad37dbae211f@kernel.org>
 <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAGdbjmJ8qk7FCbGU85u9+db5_RtcrK2y_7TfNH+iuz+OJxebow@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6B3XZZkUxSFKLY8wAPBdSKh8kODvztfdJxEoRoOtIaw_1793213667
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 68C108000E
X-Stat-Signature: 59nbeijpa85qsao8mjo8a793oh6bm3up
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793213670-367956
X-HE-Meta: U2FsdGVkX1+Z2GKvEY7KJSAerw0dPZWbt0bYGa0WESEvYmUp5fHezYz8wp6HUkRYXdgNHY9I3pgaPNq9A4dzGIVYXz2dC7qDuXKsnW6CLGOkUl2eFfC3qS9BUpZCPn2ar/y13T5mSsT9ciPeb4qX3gLztYCJY8EcHpSuPm1hg/OQVlHvlhpetVCpty+wxSoXjxYdp0EJNcy26mS9034vw6TImAyQJ12+Jzlz7S/dHlrP5AJA/lipYNqu6s9pOwY/JcbxHj3E5fNo1E66TEGMEZyV5U7NqRO6W4il7PJ1IF4vb3Lm5q7y5h/GWsonjZlwIN7A3fEnFWMRnQCtz1TxYozkN1lwuXWfPTq2bfu/hDjPBHj/K5+fAkYx3zNFfHZKq2EUOya1oCu6Bc2+V8O67R/3UC3JlqjUypx/0Jcqux3l+Btr5npeIi6wv1fWcb0DiCTSlIM08+uBMtF2Fj05tcv9/PjB6Ik3SFf48KKDMc9ugpXDyh+9T/mowZXcWl71dx+M8aap1OwIeY3M8TZxf+BJHuNOVtb1SBP8NK0+fSKoi9JoiUnqPJ0RSpUqU62WdqiGKQKbOO/i+QsxqRKQ+1AYOhLDZbkYiABqVLrts/WooVKLnXfeZkrVt5YjEzMaPK3ZmYFK8KZsOI73rg4vS1mEWmgUV3QkhHMQD1hwB6nOjlCoGwPcQhRjZ5z68kH0Kxlu68jZUvUKcjznmxL7db2/SlxhbcBLQU+y3L7oLRNrtwkzLUZGxhwFaAf6IGbHWqK0IB+p5qIx/FkcebL4QCiylpUTbSHiYHQ/l/Gyti37R/ZrXNQrim1kVKMukwv347JRBKxWkunqPaby+9ocMFRoK0trxqU+l+6ate6S7Q7T6+J/YPNf3/MIX7QHnsiSuk8M3MoR1UiikeXzXukubMP/k9DVYEby52WrOaeqrMANrTeJrOOezJCl/IdyKfoYz/JIolRieCchDHgfbTJ
 D5pIawX8
 uDqM88WFZ4Jw4fD36SHSiEK81S5r2B53IKJU/MQIIDMKdLjD0eKgiTshbMSBn5ZtCQhJPkuvgRkGnKqZsuJdHBqAxUweoXdNS6OrIjd5U7x2CDDYJNKq5kpms8RNoIHkEAUBWafNtAJaRMLzpcvs3OKaqwfETPasFnGR57x1E9folTbAfFZX3CfrpA/BwwHJFT1QXH51SAGVqWWadYDg9+I2FBEs4fUlyrxqMahcJkBIBByvdcSFkMxOlD12MSE0KxfNcSo1AJvI27TONyiL0jp19hjveMVfge7zlxkpmldXho9xracwdn7s2L36HhGB/e4zwSOqjM4vbOPKmMTjhNgVbAxHje98dXcEoA6QPQk6saHx/X98Gl16gOar8+s2F0OqCK3ddug+pv38CQMqe2JgkTQQW9nX4wKtOjMdtHytJx4wB7Is6tvJQTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:12:47AM -0700, Kevin Loughlin wrote:
> On Wed, Oct 28, 2026 at 2:01 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/27/26 03:56, Kevin Loughlin wrote:
> > >
> > [...]
> >
> > >  mm/page_alloc.c                               | 248 ++++++++++++-----
> >
> > This diff stat should give you a good indication why this series is not acceptable.
> 
> Got it. I will keep that in mind going forward, especially if I end up
> attempting a v2 that simplifies things.
> 
> On that note, I believe the majority of the bloat in mm/page_alloc.c
> comes from...
> 1. supporting the legacy inflate/deflate option
> 2. introducing support for various page sizes to be unaccepted
> 
> (1) I can get rid of by dropping the inflate/deflate option, which I
> think makes sense given free page reporting should be sufficient to
> enable dynamic guest downsizing in cooperative scenarios.
> 
> (2) becomes simpler in part just by doing (1). For further
> simplification, we could potentially restrict free page reporting for
> CoCo guests to the current 4 MB MAX_PAGE_ORDER instead of supporting
> any order 2 MB and up. There's a trade-off here for reporting
> effectiveness under fragmentation, but perhaps support for 4 MB only
> (and its relative simplicity) could be acceptable? Especially since we
> would then maintain the invariant that all pages on the unaccepted
> list are MAX_PAGE_ORDER?

I'm not sure what is meant here.
But if a lot of memory is free and it gets merged beyond MAX_PAGE_ORDER
and then it's not reported, that's counterintuitive.

> If I can sufficiently simplify the changes (especially in mm/), do you
> potentially see a path forward purely for the free page reporting
> aspect of this (dropping inflate/deflate)?
> 
> Thank you for taking the time to review, David!


