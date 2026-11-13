Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21C7606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X15Q5nmx
Received: by kanga.kvack.org (Postfix)
	id 081316B05BB; Fri, 13 Nov 2026 09:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058BA6B05BC; Fri, 13 Nov 2026 09:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0C96B05BD; Fri, 13 Nov 2026 09:11:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D05F16B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:11:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D9071C2337
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:11:18 +0000 (UTC)
X-FDA: 85430283036.04.621A2BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4CC5A0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:11:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X15Q5nmx;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CjpUzx3i2QdrmQAq6pyxpP9zjeEOXQZCXG5tsLV8P14=;
	b=ohgaS4tPZQRJlVIk4nsFansDzJ5kgmyX9W/cpLphLmzIsqaVuaNw4xEXo1Kszj5V0zTm8b
	GzBfJ6IjV0QyGBeoaX4Mexf3Yz4dtyh8DjTB2vx0bFv8kTsI3jaUoMrUPvfnmIMJ3+LUFh
	rcwTygG5xDsxyHSYmyhcdwzaLJOSjcE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794579076;
	b=13RR+cVKfS1KQgzqIngfpcanWJ080ilgSFXDETenivuppWSev4jaKmnU5L4tEe2xoK7SQ8
	aO0kdiQFWoOLw1d0uT+RCbmBpMLsiZ+C5lrX2EgQPoxksKKrDy9qVuYYzUCreDoNQxdxZU
	SnBdeFypuiNVnlFGFtrWcexCY5/YcAA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X15Q5nmx;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FF8662760;
	Fri, 13 Nov 2026 14:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3311F000C5;
	Fri, 13 Nov 2026 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794579076;
	bh=CjpUzx3i2QdrmQAq6pyxpP9zjeEOXQZCXG5tsLV8P14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=X15Q5nmxuFshajAZkPpInhyRazb5nks+5oxJpPWIlwieizJe28gJhNw6rIG5J4PUO
	 9JZ/KbhgKyywd/E5aDHxjd3O8taPmq+BGUrhkPPIA8OPBqxaI5vkB94dO3yp9mp6DH
	 1eVdBKc0EL2RrdR2sYaCa52qwdz/QaVopNQTzTvp2JFnzwOIaVZDikAKfH1/C5goJL
	 hc2Z7eUbht4e86unDu7fWE8CoOaaLmFWpb0oPoGm20Wy5i2l4YE/amfkcA4Xiq+XXY
	 QEK4oPUuUK1H19jttADclCp8vi1CHj4mTe/pK5HFwNy2IRqZ2n4OqcmCZkZFIOjNcU
	 0m5gm2tNeWK2A==
Date: Fri, 13 Nov 2026 14:11:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Oscar Alejandro =?utf-8?Q?S=C3=A1nchez?= Lucero <aleszlucero@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/folio_batch: document missing struct members
Message-ID: <avcabz1mf4Zo27DW@gremlin>
References: <20261112-folio-batch-doc-v1-1-e5a1c013e4d6@gmail.com>
 <5ca50c99-8dfb-42b1-b593-16bf264581e8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ca50c99-8dfb-42b1-b593-16bf264581e8@kernel.org>
X-Stat-Signature: 53rd9cagi5pwient1rgjd1boxa8fdptz
X-Rspamd-Queue-Id: C4CC5A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794579076-120841
X-HE-Meta: U2FsdGVkX1/loj3Xa6DsyyvPiybZG31kzgtUxTFPt7MmGRY22OIxmutc0SukzI/7RnGxPUDGd9rBEdxMu70etNxqOp/8axJILWb4AId8drtlLEb2TMvIJkFVDXc2WrsyLI8fDGKRhke0GNHd//zB4WhDBsQHoiEUzcuJHlMyICGVHwFIeZZRY2PuhihiUDtRpOjkPTEdx8DRqp9qsWk/9cHFeQ7k8SYEaROzF1KAPWMxo2YjOLpXtDqjME9FT/sugbhEaEQ/LRId7U6bY8RXDDRpVrabB/iJqe9jbUnqXR5ERg8PpAeoh+mgsABzR2qNhO/tsWLrfeazqiMTZ1H5tr25VG2Q9+socx5jB2RmwOAmkm8FyKY4OJzt5dLRLt2AXkkwuxJhyMgcfc/xlwI+bCbWwnF5hpMe+6YXGMwZUn+a31uI++Dn6v1OVoMnK6suf1L9OGKwYNqDg81rpIIqmRbAWQsIE2PTR0syBLm+Vdm8/GppSwnIk2oSUkG1pGgLg0cWJWsOFIAX2VNOjRN2EJUAWl9uz2AK0ClQespRlXcfJaiGCkERT9CLTw/42MNihpMDnHpLwEJbPLVyF9aovwMtGCMMYlTtwA7Qo5XXJlHpOkUpqYVa9yxgoQ13TzCyu3rBguj1Z1InfKCRJkOsprSIOBIxAYoLBOCOxSBKeZ8KhMiPcVRpFaHLuav9nJlBurThwu6dvpWMKCtzRMxfognBoLk8cVQFGZTIDchaYuudPaXFEBV54kIg/6UmJloNxJj5ZgfGNQTW1ZBTXNhOqcyg+j9W0ZcFqbOaXh4aqqgp5ZTW7coInf52xeoEwW8S5yK+46/tRhO7MOo/ApxKfptwS43j7BbGNt7Y1ptph3XJsLFuMPvkHpVZkH/UPue5UWONpIFa87XJLBZsjG/NFq8fZNqPtJtATZ+Px9gNFxe985gRHUrCtirjKedI+Mdhe/P8Elvhj1Sdjyt/FlQ
 QoCWDtt7
 zEprWYlBA4y8uwXmr7vA4+jerq6leARbawmT5faDg/pF8qrI+iPu0a1FDhqkYMOroJRk3gBKWR7EetjkDq0e6ZoDd8p0sfWmj2VfJ9sMju4pFBmwdPXd5wnjy4i72PqYx5CSLpz62ja9qaOLO2FLAIXPSyJj/KuwOF1eHi45AywZO5ZF+70rGLO05b0O4vP8YOA1PdMBFj5EOURt5aJA2izhdUr3pEOzyafHtHYTyfu9XadXpI89quuaEUnPm07wHNfxAWQSSEF9YO9xwlr0P+H45ZnrwMVEv3LqxCjHuDpVtOg2iatJBwV3URs4IRFkv+/Uazmj9ExI5gCYcIlLMzLQof7a7g2i6FaTk4uAXj4WFHPE4o245GO76jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 11:17:49AM +0100, David Hildenbrand (Arm) wrote:
> On 11/13/26 05:10, Oscar Alejandro Sánchez Lucero wrote:
> > Add missing kernel-doc descriptions for @nr, @i, @percpu_pvec_drained,
> > and @folios in struct folio_batch to fix warnings.
> >
> > Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
> > ---
> >  include/linux/folio_batch.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
> > index b45946adc50b..7731dcd249a8 100644
> > --- a/include/linux/folio_batch.h
> > +++ b/include/linux/folio_batch.h
> > @@ -18,6 +18,11 @@ struct folio;
> >
> >  /**
> >   * struct folio_batch - A collection of folios.
> > + * @nr: Number of folios currently in the batch.
> > + * @i: Index of the next folio to process in folio_batch_next().
> > + * @percpu_pvec_drained: Whether the per-CPU deferred LRU queues have already
> > + *                       been drained during __folio_batch_release().
> > + * @folios: Array of pointers to the folios in the batch.
> >   *
> >   * The folio_batch is used to amortise the cost of retrieving and
> >   * operating on a set of folios.  The order of folios in the batch may be
> >
> > ---
> > base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
> > change-id: 20261112-folio-batch-doc-fa4f7e18ec85
> >
> > Best regards,
>
> Waiting for more review before queuing this.

Dreams do come true ;)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

