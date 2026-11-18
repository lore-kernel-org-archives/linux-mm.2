Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13EC606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nvl0qdtA
Received: by kanga.kvack.org (Postfix)
	id 754706B0654; Wed, 18 Nov 2026 18:46:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704576B0655; Wed, 18 Nov 2026 18:46:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B756B0656; Wed, 18 Nov 2026 18:46:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D60B6B0654
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:46:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F1401A08FE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:46:08 +0000 (UTC)
X-FDA: 85449875616.28.D229CBC
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F0321A000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:46:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nvl0qdtA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795045566;
	b=gFNSZQhoj8gbRz7km6Ivxxw5NVVELhLw4sTL80SbbnbM7Azmu1GashbQoifiw04Dt5dfIM
	ZpaIrOmNoKiTF4y2tWY0Z+H5GEnpTMnEX+tWL7oNhedPnrIiHCOrKOvEqfLn8KT9dt34re
	gIUfDMd9lA7IAmS8Pya4xLHULjGi/18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795045566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Mlcn6Z7k5JuV2YJbcakE860i/4laekzSJhBTVmexSI=;
	b=dX+Ow9alJ9vKy/tGXRbmMth3sKpliVPoAQlefG1PveUWxX8BWr1RdxdoOfF5JJoE0xfeR2
	ta5QWNeyoq/Wf5RTP36EyTOgHamUdpLhnnBaWoMloBwfBUgTUOUCaizo9A37gSKTzxgtnN
	psYQ/wiaCStOgeHTDfCGydnD+qegrmY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nvl0qdtA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so1482739f8f.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795045565; x=1795650365; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Mlcn6Z7k5JuV2YJbcakE860i/4laekzSJhBTVmexSI=;
        b=nvl0qdtAIbSQIpMbtUwkDF1VGy7M2mjJtCUV/FsQY6fm8a9Qum+lChI/ThJnmOofCv
         en8Qz7Tz/lg6Q0IajK6lMGijDPOYIGvwW5E/ux63ABLpmDbL9zbwdBZ8vG9Q6+RBH5d2
         plvOJtoKLoauPTTdCbFzy4bWZ9Pf8dakPIhs85Al76mCnU74UNqC7QbXM3GsdnLB7cWJ
         otkeN8iew2IVGb+q6Ze0yBiGPCqjm0XXhhwE64So2CnxdYxFr7YpEX7AxbO/RzfZ6iYm
         QWn4Kj+D7bBhcHzjU2/E62pFPZdojKGMVKuxZkqTfLcaeftAI6mDdsMI5iTKtf5ruBen
         ueAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795045565; x=1795650365;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Mlcn6Z7k5JuV2YJbcakE860i/4laekzSJhBTVmexSI=;
        b=k6Rg9oUz8egyhyW5ccy5+eFjK79CQz326dr3gvtSiNAtxO0Ghhd3+jv43ZXkxqbWI4
         Y/c8QcgPa4WEMdA9pFlNAcpwzTjdv0LmcAkt/u7EfXwR690zOvGSV49QmzC+CE6bUFr+
         fexKTOYOhdGzCiJEjpC5qOehZ3UIr2T9z+V9jPNfTnh9VLPDKqUgOydjhObuc097adyA
         FxQzPF+UBGq+Ld0YXJtIjHOiz6UFdOidT7LlujCwKHZbJZWtlW1+pCAYR5WUqY1CR3L+
         e0UbOX0oREcekwghfiOS3nmksSWyPZ1ewREcWkQeXKjGnexgXsA36Fjmpk6PPEwufJfL
         yPNw==
X-Forwarded-Encrypted: i=1; AL+hErHcPjO+DqXh37kAd2pva574g8WX1aXk6jdADnk15veE8kzVvSU7ZaslEFFKfLWwVh9ALAc/ZsuSnA==@kvack.org
X-Gm-Message-State: APuU4Z8aCal3LOAwcPKj7X6olhrDNBwS7yWubxEXFPLyT9Jds02eqwlk
	3OgqPpEjEfGkrwhyHnxkl16dI7hxyjJ7dwYS5Dg+OveEfbwBT/EnHWJp
X-Gm-Gg: AZFdTZcIxwPWAUlPVthbCN/Di5PbYw/cmMd+WMyilvY5mPGILrnijXJ5/L/PO+aOXnb
	foPF32jKdHYAAduijjTMTO86RpSmp9mPfRurXY5vLINs5L9Ir2CWxJ6aDeArurTm/6yktoF4HBd
	kONUZUZj7n1alDMu2EI0aKCgrQDBZHJnMGtELNK+Qg/RBJiF2v0S3ulN0DIiPrW5GKVypR+MCH0
	yYKFdIgEFXoxula0Wt0EgxVPTxUa5hqwYhUDOPRejbs2tSA30yjqqI9SYWGD9drnXT19ZEFrDfT
	xjRBb4sQDnw8Qu2Ji6erR358ySsRxnyoKETBxKJNaiQIMCMWq4KBpkamZO2m9UqPdXjSbN270Gj
	925RPwjFFWw5AGuIyUwxy9MsSktGk/Iq5puHztqo5VCtm6JTYJeHSOU8ek160VKaMO815wJ+rwo
	cG7QQTng39CGRPKO3AIgWtogTxEDeXvNBl8BvZdRuJGFgnAsjFOLH2ds/4DpKGvU9IZSva/rcPD
	1CmBmB2vk0CAsK4oi1bRPTjAG5r8zy7+27aykLXNGMTm/ilmTAE/cNqv0S/FuB8VM4aG++SUSgX
	lbXxbrZMBGabJDygfc+zKbZc
X-Received: by 2002:a05:6000:2406:b0:4a6:a5f0:be41 with SMTP id ffacd0b85a97d-4a6a5f0be8fmr7445862f8f.54.1795045565105;
        Wed, 18 Nov 2026 15:46:05 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a6575a5c28sm7553171f8f.59.2026.11.18.15.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 15:46:03 -0800 (PST)
Message-ID: <09a96936-795e-43f6-a6db-03f30f20b5a7@gmail.com>
Date: Thu, 19 Nov 2026 00:46:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/userfaultfd: check exclusivity of the page being
 moved
To: Eric Li <nakixii@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117212400.1890820-1-nakixii@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261117212400.1890820-1-nakixii@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9F0321A000E
X-Stat-Signature: ea9q5z1q9sowpakkbaxf15eqn7gfsym9
X-HE-Tag: 1795045566-746361
X-HE-Meta: U2FsdGVkX1+n4apVA8IN5cXDKPNqG60LSlp4NpSF8jrE7kDkZyMhFW9aCBzqBTgZcP7ESdwlPjJaMDuCyJslW4VkilcLKoE6W394iEXEb8CTo/Kl3JIk3RvOG4nt3K/cFirArn6rRatPjvCH3t0sZiTm1OmKL8hJ/o6bob+i+ElacVvTon1PCSdMH6oK1eEXXG+/I6foxsnU45wjlLmOKWBkM7r/zqayxc1lREgousN//Var8INZqwEk71BLd5BjQzV9nTEZSSAt7SxDVE/xc9AbIKmCTWY0LjxkptJIJOuZEDdTLC3EqBLHc6Svh3K9cquQO/7GMgBRwR2qUhFvuQIJcI4H/jDnRiHaCWj/YGQAmaeMteTSFGyLy2nk2rmg10TJz/I11xdDaoWMQWSSk12ZOPepe5KNJqekJR23rAkyx3b6c/EbAm1OIKLYV+nhaWW2C391CtLIH9x7TOPYphLfwqbXVE51ZVKcr1Khiza//6sVZzvbLIDl26iE+f20Rs+X5GD+oIReC1R58aPJlx2XVd0DluDz+7wM33e1tHuWFWTCb0SmY5LhKopkLa9BuBoE1MKm8RYz2tHHHYj1HwZWWvlcb8HVDnY+vV2Uth4lpZeKKshbjyGrh2G/nAt5KrJnA9feMkXPE67LwQXi5mj1E11YpGHAhwabqd6tnjiEnUsgK40/TS+vNLg3hWcTdyN8gKHb82D3ygSVk1pA3oUM6lJPSWQHNVqHxmUzewjG6AM43Izy/c9b7lxcvdRTWbnnfLXWFg4s2+aXM8nDxr1Y8WA2CRRHHkG3hnKlzOHthSRWQYd1Yx5tK7xsAMUesc5SuXCD9Xg62mSznttMwaSifvPeWKFxUN8m+1xkvz54KIf9H0Ne8KFFCCIyyZ7guWhaU74IgzTMOpJ8QT8fv2pUZlkAwM2Oo3C3IC8YS5oQnm+pNxsKYUUFkj5luhO0Me0tv38fBy+pevS8jco
 uGiefgpO
 cQcScS21tT3eWFXqRBjTDu+bITX5UYAzriKZ7QgAeE86d1WHFVMS6dxltLHNtGxlkQuIDV2IawbUh5FIMIHCPZCnRgv/tSeXik6L2oWvnbDhb1GUJ4KQwC0RAunmVJotuSg/1pZqixnsWS1Byf9CV44s+T3vg5tGTzGjNsR6G8QLKkk3Y69/59ptpyFWfWsqkY6jUqpf+53NRMzFlXAg7GVTAtUScBbvWvWaIP2MfdhYk8IXHpk8a2vqEexfFaeH5YbUIL+mZBWh6u4i7j6IcIYswKsd2KdnZAupbQqCpFtqvrRybiI68Ngqzv/fBCxKryiIAh29EE8mDXyY/yYUIH5Iae7Cl7wK5E8losZjTEBQApvir6HICsl9rKkqUkOFDXfNuZQzsPK5SlkXD51NQfg782EjtlPZssgLrTw5Vx/aTuEYp3sYb/1T1kyp9D1uQ0iiG06LrZh5c9mj6PqAL+HIML4KTGVq4RyBl/C9vWYhmno66rO4PD/AtlXVvYkk8axaeZDrLG71OCn2opm2RALJKceQwtS2zm8wRQiFGMpE6yzhYlyW8G8xYrrgnZuJCntWxPFTP5HY1uweBuZJE/bCTGJ5sGkQrdSufzFTJqhM1QfybyiydXt8rbALPvpEKKJaY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 10:24 PM, Eric Li wrote:
> move_pages_ptes() gets the folio of a present source PTE and then checks
> PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
> is per page, so for a PTE-mapped large folio this can give the wrong
> answer for the page that is actually being moved.
> 
> This happens after fork().  fork() clears the flag on every page of the
> folio.  Once the child exits, a write fault in the parent can reuse the
> large folio, and do_wp_page() sets the flag again only on the faulting
> page.  This case only exists since commit 1da190f4d0a6 ("mm:
> Copy-on-Write (COW) reuse support for PTE-mapped THP").  Before that,
> the same state could already come from fork() after MADV_DONTFORK on
> part of the folio, or from reclaim when try_to_unmap() replaces the
> earlier pages with swap entries and then fails on a later one.
> 
> Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
> the folio could be split and the page moved.  Callers that fall back to
> UFFDIO_COPY on -EBUSY end up copying instead.  It also goes wrong the
> other way: if the first page is exclusive and the page being moved is
> not, the folio is split for nothing before the retry sees the shared
> page and returns -EBUSY.
> 
> Check the flag on the page mapped by the source PTE and get the folio
> from that page.  Locking, refcounting and the split-and-retry path stay
> the same.  The batched path only handles small folios and the PMD path
> already checks the page the PMD maps, so they don't need this.
> 
> Tested in an x86_64 KVM guest on mm-unstable with only 64K anonymous
> mTHP enabled: map a 64K-aligned region backed by one large folio, fork,
> let the child exit, write to the sixth page and move it.  Without this
> patch all 20 moves failed with -EBUSY.  With it all 20 worked and the
> data was correct.  Moving the first page right after fork() still fails
> with -EBUSY, as it should.  Writing to the first page instead and moving
> the sixth fails with -EBUSY either way, but without this patch the folio
> was also split all 20 times.  The move tests in uffd-unit-tests pass
> with and without the patch (the two swap tests were skipped, there is
> no swap in the guest).  I didn't reproduce the MADV_DONTFORK or reclaim
> cases and didn't test arm64.
> 
> I found this with Claude Code while debugging an out-of-tree swap
> backend, and it wrote the first version of the fix.  This version, the
> changelog and the reproducer were also done with AI help.  I've reviewed
> all of it.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Link: https://lore.kernel.org/all/20261116110122.309748-1-nakixii@gmail.com/
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Eric Li <nakixii@gmail.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

