Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACACE606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 19:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=igzDNYAl
Received: by kanga.kvack.org (Postfix)
	id B9B976B0851; Tue, 24 Nov 2026 14:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C4B6B0853; Tue, 24 Nov 2026 14:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED966B0854; Tue, 24 Nov 2026 14:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9736B0851
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:55:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1CCB120AFE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:55:15 +0000 (UTC)
X-FDA: 85471066590.19.014AD24
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25D5A4000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:55:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=igzDNYAl;
	spf=pass (imf11.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795550114;
	b=ihtDs99oVOkAA9sb1r7Bqoe66QCaRX3dXReX1aiL2eo+6GdQXKZOVITPAttpG/l+8RGRpl
	5HUw362G8K8xfshkiEUKRkuW8lKUK8HWfPzuIpmPuneMG/Wh/vVJSoBRlTGE0zTmHEvJ3e
	1YljkBqHBEEPq/cCSEa8THxW0AxOx+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795550114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfXL7pTzXBkITvsNUdQnzu2e0Gb3CsC6gpsm26wxQeI=;
	b=8XoM3MPXw61e0AxxnP6OSaipmU8fiCazfASxzaJn8IPdPx0+eBsg4zr5Y00pjfDyy5SyvJ
	2DZOLaRn05j/ZIhEI/s2u66dmPcZFn/k9ysBgJcdN2g/R57TVH21cU/duVPbylPV0xQLfa
	N6Wk4dk58e8vTB0pZPbft5EDTo8Ah6U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=igzDNYAl;
	spf=pass (imf11.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8b5e147f101so417585b3a.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795550113; x=1796154913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UfXL7pTzXBkITvsNUdQnzu2e0Gb3CsC6gpsm26wxQeI=;
        b=igzDNYAlKn37G7MhlZWDXy7ICOK4YHNGt/f8EqXcayvv15qIf+1RPmJll+fXmr0G12
         txrVCyY+rD5eYSG9NzNc9LeDCOef5pGTn5mohFDE8xtHuk9xHeftyxo84g4d2tRfZw6U
         x9nvO0ePGzG3wUdi9rIW+t87CLjKHhW4g7koI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795550113; x=1796154913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UfXL7pTzXBkITvsNUdQnzu2e0Gb3CsC6gpsm26wxQeI=;
        b=x/Fe4R0TEpGVxJYkmiR/L4llDbGhRtZWzkDNFtyJdiTTw/ghv2XaRYHK2md5bMDdm6
         ZnfojbyTBDtVS10ynM2lnE2/xqOpr/r1KKtE8ZEx3Z7E1Gaia7ejqxHHWxMzf9qSMm9N
         QG1ePyXT68UxIakLJ3LNVfl1uagG90OfSvI6ILuPtiPsZuyfpFgQ4CqP+Xehv1VfiXTv
         D07CTOOYBIvDcsth6EFh9lTJTu+s9Jdjz7Nm7YnX1u9GCldmyn20XUBsw5qqZPqRKSME
         feCUE+YVybUmSH5XvLO6Gi5l+xSOkGnh7DRF/BU7Rdqyl+YZ2p3tWaQngHvZipDTiKqK
         +0BA==
X-Forwarded-Encrypted: i=1; AL+hErEaVbzbPbgTPAsq44QBN+XAFBeKUC2PZt31UFODAAqTaqwqXdsGzXda18R/bcCCwuh+KqRUL+Nc5Q==@kvack.org
X-Gm-Message-State: APuU4Z+a8i0vjkHRiW4fcUDU+5sAlQDD9kWNX2hsihGO6uS9Qlzkz+z+
	bmsLROLdSKlF/XlsVdqS10v0jrDfWDg6m+WbvbpVKKvGgJVCVJlW2NLRp9bDLjG7EA==
X-Gm-Gg: AZFdTZc9RrRNzK/HbHMV0yh6iDY5txvUvQJWZwRMNiAfh1ywFQfUTGbWKwhvxwNoJO+
	g31y60wE2HwuehTlr09anchlwJgRL2blVNVzOaVVdTl+1fVVV9TE9jkDS3+B+9xp+sstHt55Bt5
	bKqfuDoA5A5MCLTmLXJzMSrwy876QTyEh5kqvMBJlp/exdXeL4vdFg0mxe1ieYCG5+mKT25+KRF
	pLEKh3KezXunvFJ3bNTFRLjoA/vPRozKzNcbi0iHXv+Cqh1RCUe76IRx17HAm6RXGEKuaUtmXaF
	TXlLVF5bGL2xyqQecKMHIHS7fNrWY1PonNAUeqZmnlsnooNFWWE0d6kx74LZiL83icDFJU2JrO4
	Ga2jFq4WheM6MHLOOsES/7d8RYO+b+kQXwduFhuRoTQAwSs8791khOephSqh7El9veBXBNNx2g8
	saMZtSeWaDQAgWQz9PZL9Znagi1hkZTBNWF91uEBzC9DLsm0V7yaaB3mLJg8eM1KG5tSOiRHKsX
	X+zhRDTUZQAc/qzSva44l6W3BnQ+1VMKNo43GHedSJABpAv36pJO459NGi1ABrb4Vv3Pi4LhZwE
	IBdXx3ab77yZVCYGd6KKX2EQuru7c+Z8U8SyBq8/U7qQr8DgUIGxhO50oLsJ/b0QVVBZxl7xbYi
	jjS69+ANErKf3JUQ=
X-Received: by 2002:aa7:804c:0:b0:8a0:646e:7e16 with SMTP id d2e1a72fcca58-8c87b4f38cbmr15568834b3a.2.1795550112810;
        Tue, 24 Nov 2026 11:55:12 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8c872e4c43bsm7550418b3a.26.2026.11.24.11.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 11:55:12 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: David Hildenbrand <david@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: add page_alloc_skip_kasan test
Date: Tue, 24 Nov 2026 11:55:08 -0800
Message-ID: <20261124195508.164641-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <74dd67a2-eaff-4bbb-8105-4481fbbdd016@kernel.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org> <20261123033111.2349160-3-jeffxu@chromium.org> <74dd67a2-eaff-4bbb-8105-4481fbbdd016@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25D5A4000A
X-Stat-Signature: s6eg6hpkif5myyu7x17r75u3sobf3jwm
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795550113-374933
X-HE-Meta: U2FsdGVkX1+tBu+VAW2C0u32vvEQ4qNxCeklDO6MjAkPryCxRvFAqwKSSD3XiBPynDEwo3H3hNhNsFty1CIlBvOL2kHcA72oG9ByaEc9HanMvDdzzkHLpOawsQru5OxyAoMGaA+hqJglZZSz8GomjsE+XSnFNCDib4CISKIai6OU7GR04NyVu8sSqmzrV1hWTH5b+9xz1rlf3lRznIP03Vu6+2KD1haUYxT+2Kngty9PAE7iTJ1orqnT9ODko/0Yg45VDD8lAGjZ1suSdx7PHsGD7JYnPUYlbxBIex5IJgl1kN5vX07BIei2KGRc34qlVCv5sJaEughgWyECnzuZ7UZL0XEeWgNUjxc1xak0chGFqV/xrNTjsDZng2DtF5ToZy0VrlZZ/oYK7Mq5MrOzt47ZBz54BX4BQfAAFcOnBzfIpK61mjHIKAWsn8svLVO/P67zd6MQFSlkDr8VqIYufBcDvckAW0B/WWDl9bvhx63xwolwHhXI7T+F7M6i411OcV50aV6Wn6iXfV03KVi4W72kobi7BTK1XmNmnqr/OO/azV93xwMxA84xT+7rOkomFprpUlgFE3p6UlkUl6Ct0lUTtiouHECNcpCZhkdRwalcIzjYCMJSU3tbSGi9JVr/qzCkcMEP5wGaj1LEdGsFpkwsmHD91qx25GMl4IPnETuxSDZCpLccTAdP80ESb3Dhsdu9STkj7qqnMW5WzskJ5ejpqzi/KMmVgLFJEvr7KO/EHrsEODuwUL/alNsne0anaKVDKUr0aH6ucmOB2sPvysIZ+PiTTOjQTiZ/gRL3k/O+kDgZJK/To5kjOpuMIT5fZlnIS7XA7mDABkzPPhS25t5A0uN6PHA9k0yl2b3qeFVG1mbGdXjwuqUB0cAWM2We6VjB1q6zEmygdqzPQxhev7xT2j62PkQeLwA8lH1KjHEQmneCfN0mA+oZRTHDvLY0OwGHBDxgSa6pX7eE6Va
 WI7O1EQY
 n5oyXQeXcQhYF7a9gV1j2poWoIgjsmNs+s7xZ+04t0jBttirVCeac8tHgX+stIp4Yy4BpBNSEJpNkHC6RuJIPULZ2m40b97cS7LyKdCZCjdem58NlF8KfWioGJDH6yLBRbvIvj9Sh3Z/C7RerKFNs2NBjcEZ1bto9gbpA4ChwIFBjFduZGaFh/4dLn87IbPIECmU9acOrqemJ0VyktOA5tS1l4Rc6ZODmhnO/nNukk+UD1ZA7F+eE4Qc7b/w664HcdwapTofR5UVPU++gEqi8gNn4EhvffvNE6H+O+JTsx2au6o/9/779f6er7k7H2gMnkY5cZQsMdoL+QMdnLtAO8c/96VHdsljgZH23WKpgiliU0OfdxlYxLFE/Hw9bup5TJ+hUqMQuVv5W/SA13uAqdgGRqPA5A/tCBIGA+jMqu3np4cg3XzXAs6pAF+HHgX48ftS5aYD5MMIxJ/yZBfgV8bC5W6ahLlSsO5lGtMLkOriOXNansq9ZJ8/SmkZCnOR6EuuG31zUzFMrYwPa/hT0Uz9LHTDWqvvUvvB0sg6LcaXIQoFAXhASfzdyR6z+jOOpFGNGP/17H1TQG6fl7pyfFWsXkwRbY6AjoYHDCXYsm6AM/PUPkeM60GLHQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:17:45AM +0100, David Hildenbrand (Arm) wrote:
> On 11/23/26 04:31, Jeff Xu wrote:
> > +static void page_alloc_skip_kasan_helper(struct kunit *test, gfp_t gfp)
> > +{
> > +	struct page *pages;
> > +	size_t order = 2;
>
> Why magic value two?
>
> Should be const.

Just a small non-zero order so the loop checks tag resets on sub-pages
as well as the head page. I'll change it to "const unsigned int order = 2;"
and add a brief comment explaining that in v3.

> > +	char *ptr;
> > +	size_t i;
> > +
> > +	pages = alloc_pages(gfp, order);
> > +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
> > +
> > +	for (i = 0; i < (1UL << order); i++) {
>
> "1 << order" is sufficient.

Will change to "1 << order" in v3.

> > +		/*
> > +		 * __GFP_SKIP_KASAN allocations must carry the match-all tag
> > +		 * in page->flags, and so in page_address(), not a random tag.
> > +		 */
> > +		KUNIT_EXPECT_EQ(test, page_kasan_tag(pages + i),
> > +				(u8)KASAN_TAG_KERNEL);
>
> Squeeze this into a single line.

Will do in v3.

> > +
> > +		ptr = page_address(pages + i);
> > +		KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
> > +
> > +		/*
> > +		 * The memory tags of such pages are arbitrary: stale poison,
> > +		 * or tags set by userspace through PROT_MTE. Accesses via
> > +		 * page_address() must not fault regardless.
> > +		 */
> > +		kasan_poison(ptr, PAGE_SIZE, KASAN_TAG_INVALID, false);
> > +		KUNIT_EXPECT_KASAN_RESULT(test, WRITE_ONCE(*ptr, 0),
> > +					  "WRITE_ONCE(*ptr, 0)", false);
>
> Why do we care about checking HW behavior? (match-all working)

Good point, match_all_ptr_tag() already tests match-all behavior in
hardware. I'll drop the kasan_poison() and KUNIT_EXPECT_KASAN_RESULT()
checks in v3. That also lets me drop the local ptr variable.

> > @@ -2369,6 +2412,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
> >  	KUNIT_CASE(kmalloc_large_invalid_free),
> >  	KUNIT_CASE(page_alloc_oob_right),
> >  	KUNIT_CASE(page_alloc_uaf),
> > +	KUNIT_CASE(page_alloc_skip_kasan),
>
> Don't we have to limit this case to having actual MTE-capable HW etc?

No extra gating is needed here: on non-MTE hardware (or with kasan=off),
kasan_init_hw_tags() returns early without calling kasan_enable(), so
kasan_suite_init() sees !kasan_enabled() and aborts the suite before any
test case runs. For Generic and SW_TAGS builds,
KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS) skips the test,
matching the rest of kasan_kunit_test_cases[].

I confirmed this by booting the HW_TAGS kernel under QEMU with mte=off
and with kasan=off: in both cases the suite fails to initialize and no
test case runs.

I'll add a short comment in page_alloc_skip_kasan() noting that in v3.

Thanks,
Jeff

