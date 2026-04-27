Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49E9FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262C96B0088; Mon, 27 Apr 2026 07:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A386B008A; Mon, 27 Apr 2026 07:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176D06B008C; Mon, 27 Apr 2026 07:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09CE36B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:35:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A345C88500
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:35:04 +0000 (UTC)
X-FDA: 84704129328.08.8A4B3E4
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf10.hostedemail.com (Postfix) with ESMTP id B174FC0009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:35:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=b79Pn0kp;
	spf=pass (imf10.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777289703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZJjWYJEBe1j1UXPI8uSHg2lT/Aimpgb4SQ8c8oJ6jA=;
	b=hkzaC51/fkgPnGQWISiPqlUyqBKPq4reNDDZpg0Mn6yBh5BCETRhDGe0LCKd9qhiCfJbk2
	Zx0+yDwdFp6CWVugi540jdGjtqfG5h+NXWGe5fEoH4r6jvej5ZZItj3hicYfLXXEwLbEXq
	Py/41syROat6k0rafdyp/Q11O4IaMCs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=b79Pn0kp;
	spf=pass (imf10.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777289703; a=rsa-sha256;
	cv=none;
	b=gRFJjF9YtJUA+5NulAe00D3oHoaoDC8jHSK9o3HlngEcrim11XL9TOD1zm+yNQySA1JPb4
	CrTXMdFiBc1iBKzlW6Z+Q2bflHB7yQ5ENgRT3tlPRm5LBD4P6HeaPsfRFQcTEEgsGRg3PG
	e2fW5AtKCgqSTOHLxwfE0WlZg/7OMgM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/ZJjWYJEBe1j1UXPI8uSHg2lT/Aimpgb4SQ8c8oJ6jA=; 
	b=b79Pn0kpRLWY/63lVphIcJgh81kotGsdlZabp4Xawl8+qSo1+NyzQJlU7kvoemOpWdTgKzGwI/t
	wgi7LvUnMco4NLM3YDYRuTIXCLFLXnlakiNmfixEnHk40bpq1Tgt9Z/U/9ZIhMnM9qf996SCAuvsR
	dNfwHFO8iOzWKgZXE66RzCJ3AI2hgHED3cCtJqIKwSXkIWRXrzTryrslEEAfS3EHb79OzSa7VLEs+
	vX44zlPEoW1prpUwCtGlBKdYIwj5CCdNDIdeSiAGi45+/N/fLLTwedF6YCoU5y1B54omfBBHdu0pE
	56+D43ZBZoy2O3QsMsBTydxB+6ENaKhSASfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wHKEl-0099Ag-20;
	Mon, 27 Apr 2026 19:34:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Apr 2026 19:34:51 +0800
Date: Mon, 27 Apr 2026 19:34:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Thomas Graf <tgraf@suug.ch>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-ID: <ae9J29Tjq7wuICT5@gondor.apana.org.au>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
 <20260427043149.e8fe46494d92d561175861ca@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427043149.e8fe46494d92d561175861ca@linux-foundation.org>
X-Stat-Signature: uehaekei73a83xedrn59p8a5njyx3w1i
X-Rspamd-Queue-Id: B174FC0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777289702-321432
X-HE-Meta: U2FsdGVkX1/gV84L5+C5gHB3IKsH6GKQiMmRR990seUvYtQxbLNCktcfA9ceT9xqPlfjKmHpoADrZa/4GCIBTQX7PzmlTz6glJkHNP1WC8+W+075alU8hyRsTkacJQIh9n81n7Emtr3e9zjyT4vUBAZmS3XEL7qYFDdDL3KdtAElmi0od+/b6y13fRpED7D4MnYP+EB718m5kJAddV2zJ/x+ewPGN5saaT5a/qpNjc3oAXwAvQFptWKz9iGS98DtWouCqW970isHLIXg0Xc2sQFsHr2AmbzhTckj1JHFYBWFtFsGFpMY6wiftKA133ByPX/6VVhmeNEsYK9T24X4Z7VUHchxHeO+lLREnV3Xt+XuLtfYjPlnR1rLAj93M7yqWQ90dtfNRcT1jDt/lrv4rbwVxQf1ARAQVLYwV0uSTdvO4VtGxLhMVWKNmibjJB5pcKripveEfZUBFxew8yd61/oGXb+RHiQWnUXz13Vjtj9roVvaUKJcD2dsrmbFwr8JQgsPVFw06DGjQtPvlleic5nfAn2sEBqxkQ2wkiZFLpyZvbT0s5zgSOzTAIg90XQg0Fvpi5YdsInQbsGw2GSksuW/yiq48G3GMWrb2Tb2nppTuWatiAQHu/eiu1CJe3eJEsqmP41pFNROXCr4eTAwtYI26Wivo5uH9/WRr0o0AmkFqOXxPofSHnA1uUhCyR3r15dXMI8/Y0nPu2JuzNP1vnK0q7NQNxRKjsrL97c5rSCAl+0puHyd3rRJzyxBifDe2VJ8auJ6pey3qn9aCf/LQghs9f8aiMA+Jiwc+uaf11OOHw6AjiX7U2TGbo/Fy1MPPMiK6bApabGEAi4C/V9WVMt5trtOv5LCwDRxf0IJ5ntzjREguWF3RM7NVYeImkc42wc96FOxXvuw4l4/FrUAimTg1G6yW/pvZtHKJpQy21mATTFoGRTBfXHbx5V8uf/papCSjs8GnnrKZbJOghc
 snjGQ3s5
 D56By5oWF55Ul+87PN8wOsjtRdM9qzYTt4UEsF+8LW33appyNQ/8/xti9LbQVeYm7lL4v3N89Fq5fhILUkYITRGYfS2RHuGjrVIXVJZRMO7akIMT8CnPSRSEAU098jaKg8qq4huWjoET1MLbPfpEgujc31PwP1dhrLYbPkKsQ2IRZGB3ycfAAPEd+70pwFXvtxGj0LlxqIdUnud3w0D+SZ2+aBoynGl0p3j5GSupKnu+iXCq55op54HG41KFC/c87JHcZRMyMEZRYedYOgL26OmUmCHg32HofK5hPubC0pi21kVoDXOIV9UEvCclRmsEB3MgvTcaQmOqRrpbY8UdShsQoaPx85rSLKB9tfxDzCO/s9kIWH7jOztMMZBpjNTmmI9DmKl/E/XImTMnh9tHDEMT1IyRFj92wt1hAwYEls7G58Er8qTCIey9Vjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 04:31:49AM -0700, Andrew Morton wrote:
>
> Is this related to https://lore.kernel.org/202604211323.fac1b29e-lkp@intel.com
> 
> Are we able to identify a Fixes: target?
> 
> In the above-linked thread Herbert had
> Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")

I think they're two separate issues.  The addition of non-blocking
support triggered the vfree while atomic issue, while the lockdep
splat is simply due to the use of rhashtable in fs/core.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

