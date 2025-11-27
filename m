Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C1ED11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAD76B0024; Thu, 27 Nov 2025 05:29:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC24E6B0026; Thu, 27 Nov 2025 05:29:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF306B0027; Thu, 27 Nov 2025 05:29:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2F4D6B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:29:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F1531A0960
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:29:55 +0000 (UTC)
X-FDA: 84156016350.22.CDA575B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C73F1140007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:29:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OnWUQ2+V;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764239393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnU+JQsXw6IFitED8NhEgEEqqeSpTSuYlRm1oYBJlHE=;
	b=b/ZSb1hPnydLKD6RwbHeHpCi3psV0PSsqyp/3qUF4thoPIeC9YGbQcFaHHXmWsQineQRvG
	rw3u4LaWGIJyesiIyZmXIBn1K8HGXFbsNjLnFuRrF/W2s7conNiBAsxrQKkigiBZYjeYdi
	B2++pefBkF/y8UG2Rlnx81Bo/UBIQ0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764239393; a=rsa-sha256;
	cv=none;
	b=6P+ya2XKZMP0ERH4bOhPO9jQ45yYIIF4eJYBoeru+XbuLkkMj4Wh/MYGv20H5Rvo/goWul
	TQ1UlWhO3AAYeSuGEgNfpy/cUB4UZsIshtKV9Kcj2WjbCaw8oIIFwA8OQ8go9/S4kU+ed1
	XyWehTHLFxO+79KpruDhR41uRaZoT1w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OnWUQ2+V;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 281DF6013F;
	Thu, 27 Nov 2025 10:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760C6C4CEF8;
	Thu, 27 Nov 2025 10:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764239392;
	bh=6026FUcOZ7792wogGQD52EVUcUY2trkThOXOtUo+GfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OnWUQ2+V127RmQUz5qQzGB0tW/qhEyMXNhJDFGclXUDD3NujYD4hb5z2GL/sukTDh
	 a39tG+gjDEc1E8tOYGeiOM+lmQpn8PkPDZjIrN+Wm4gdla3sJrM64w0OQdNX5rZzlL
	 KSl/xPm9+4wC6PTrMCHte1VlGqCQzHRRFSuoDI7F14PMZc0Sy0Lrsl1figTyKIx6lA
	 MiL55H2r+9ZxkmZDzAqLuOaGBcJEMUX891x12xwUbB5VJhgtowZ1RJ4lqXY5tITFsm
	 lAwQtudT0D2wOA/mp0HsW+rhNsvk4bx4KRyWaJ0JhddoDePktlNH5N/PbrxaIO94Pr
	 febYBzhphPZnw==
Date: Thu, 27 Nov 2025 12:29:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Jinhui Guo <guojinhui.liam@bytedance.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, fvdl@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/sparse: Fix sparse_vmemmap_init_nid_early definition
 without CONFIG_SPARSEMEM
Message-ID: <aSgoGU_WM9f6RWNB@kernel.org>
References: <20251127092512.278-1-guojinhui.liam@bytedance.com>
 <3cdc6bd6-f0c4-410f-b2a2-8cc2b5d1c522@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cdc6bd6-f0c4-410f-b2a2-8cc2b5d1c522@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C73F1140007
X-Stat-Signature: zbs8dtjnsbjtqyikuuddrnizafzo6wut
X-HE-Tag: 1764239393-32349
X-HE-Meta: U2FsdGVkX18yEah6j2uIHBiv9Mgg7C1HJEOd2mW0Qa5QVfZMfcyI4AmuQ8oLqpmVD57x1m+li9gwzI4zdW3K01uEtgQaGIDrP9x+BtgPtkyEb9HJn+pKQplLCXVI4kElOZ/It+gsRA3+0OZDVpoEOPA/iGLPnYeo9zrYrBvkbMIf7kGwif3Y2zaEThuiZvrtTlIhmtwdsSZ2aVNJfp0MpfKOKPX0IdceHLxNvndnRPdvuJW7rAm6SCWRksbZDeXnQ6K7bgUHxqtZj8Lscr+qUP4n8/OcegCymsynstrSXgMUgYgF2mQcmek0xfBaXMhmm+FbF1lBmhim9bYhQ4ZnIcZ9D1Z8y7isMZSol3RiRcuMu8SqMIihF+QvwUaoGxI0A20O3SZlfPt/kIGyeoCIBS5b2Xn3wWm+FcJp0GL3lC9ID5a4O2aoANCzlvLJeO8lir9IXqkra25+BQnAKAlsGggkrvXDHTjeCiqwmRh01fjqj6pz5962ao3gfvmz3Oau+5kDqdYoVnDfQdNy5A8faWgAOIFI/e9erisJqDFujjQd70jg82nnlZKvmNV3RZvuMzUTvOUL0tPF+AKjk3sa1lG0lni3mq1sutwNt3jlOxmNGX4aLoia5mHdjhVnJ76cnjyc4j2BVefXT+vghu/iUpTX7co6rf32EQZpb4/sTiheXHO8Ursm7IyWnhRc9MfGzPFoqDSLDj/EOL+TrKIX9UeWLa0KXnTtiKDMqh9vx6FsQ9k46rI7xOCuuZa5RytuxbsZefrwA7AC07x2uhVNwtvIAgHgPdKVgiyRgWY78cU+PGaHGwT6dCL7HZBMEDMQ/vvaIM0+Q5HgwPIlx1rbKqhDSL1z5M7FLLMC8PNzq+n5mH3G6CIklLKwhlYvI7rprhVZNRXczI6c3+Bbdd46s5H8J7pU2zn/1P68Ug9uCfcTOdjlPwNV4GQVAQVTBFO2b/0jj4P/0RZVOwj7VLU
 sLHtFTym
 RavgCOgjaV25TJOKxHARnkh55+rRuFTIskAId+ZhyvSqwWwtC6sRCoTHSbbEzZSLfkEJKnpP+QjqCWb2AmEAoSPxKl8OtE73Y4sIWaUN85VaNFZRX5u+q1Jf3I3ItD5dK7w5m402Gw090sOvNYaEFSEx96t0inRuajODvRFjoUq/sN4ZUYtuk8KepsElv2E/jhzvrqNBoaFaJYFjD/PG77TA/8hHTj0ErviHttDw9m7FGWP1/EriogsMOmpu3uI9edeSYE7NayyZhqcmGxFdbbM7atkbz8g3t+rZ4zLAeY3rEInZfa6iNDJoeZazP7Edo1PqOLagQBIUntz6QyHakbstap6wrGgB49o0vFJr2HUFDLyt+sZOy0FRe0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 10:46:54AM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/27/25 10:25, Jinhui Guo wrote:
> > When CONFIG_SPARSEMEM is disabled, the macro
> > sparse_vmemmap_init_nid_early(_nid, _use) passes
> > two arguments, while the actual function accepts
> > only nid. Drop the extra argument _use.
> > 
> > Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
> > Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
> > ---
> >   include/linux/mmzone.h | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 7fb7331c5725..f6dd181a4821 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -2293,7 +2293,7 @@ void sparse_init(void);
> >   #else
> >   #define sparse_init()	do {} while (0)
> >   #define sparse_index_init(_sec, _nid)  do {} while (0)
> > -#define sparse_vmemmap_init_nid_early(_nid, _use) do {} while (0)
> > +#define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
> >   #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
> >   #define pfn_in_present_section pfn_valid
> >   #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
> 
> That commit is from early 2025.
> 
> So what are the symptoms we are fixing? I would have assumed a compile-time
> problem, but no built bot caught that?

Some of these are used only in sparse.c and sparse-vmmemap.c so with
CONFIG_SPARSE=n they are completely unused.

We probably should move them to mm/internal.h or even mm/sparse.h
 
> -- 
> Cheers
> David

-- 
Sincerely yours,
Mike.

