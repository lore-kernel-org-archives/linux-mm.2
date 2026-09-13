Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A20ABC88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 04:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FB36B0088; Sun, 13 Sep 2026 00:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10B06B008C; Sun, 13 Sep 2026 00:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9261F6B0092; Sun, 13 Sep 2026 00:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8D46B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 00:42:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B1A1405C2
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:42:52 +0000 (UTC)
X-FDA: 85207493784.09.F362B46
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 764C8C0003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:42:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="T4/4R03U";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="T4/4R03U";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789274570;
	b=DOuZSjtznunP88krS34bQJTfidxFPJUnXgiAsf+93d7LfINhcQUnK0IOFw5/6Gnyd0P8cx
	+9JQzAMM8n7M6Hp0Mnj/lkA5mMBNjUk19SL46eAjBlA+460SMA/dMBIeF7UHnvI5njgWrE
	IUjdarDp0ZdnLDzH8KCNsyO65dxUmUI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789274570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccs7gEOpe3e5tMpEkXHimu7RBYE5MxCJoaUx7mSCdx8=;
	b=mTYBZtjFLM7YC7P3KI/GJhuGg8Mv8i2sguUU988J5OCXrLKFZdpxIcwlpKCX/inpua54Es
	YWbw4+uIi1vP+bJjkwNyPHuCZFVg3APUJufc/+EACWhpqd+Hc4QDUSkeDuV27YwCbBx1u0
	1/mxf8pEo1fitl9afjtxtxLahf9Q3uw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ccs7gEOpe3e5tMpEkXHimu7RBYE5MxCJoaUx7mSCdx8=; b=T4/4R03UOXz6bk6wvuT0Y456jL
	HoSHPtAnEFbZdBgvEv8CildvupeM6Qj+pRrNQquwahZkThO6+hFQwdvbOAa4JzTD7pl0LEVHO4yDC
	DlQZdF4fytK3JFw5lv1quqY7v9gYydNf6p5QfhUaKHZaz/N+k9hufmBKWkdgMLSx188fRnY73dqqs
	Sw9g0IbL/a81mmKE3f9H+WMA2ST2pcjjcE2uVt4MMWMm7RFquHueGMpurK1w6z5Akcrxm63Om2DnT
	kosAAYktUTdNQL7SbvGxJe7X8EfO8+x/alZoNAjVBWWkJa9+7a4hCYgpgwofbKPUUXQp/X/2asId5
	WsG8eJRQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5c3D-00000003Stg-0rTk;
	Sun, 13 Sep 2026 04:42:47 +0000
Date: Sun, 13 Sep 2026 05:42:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	surenb@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	chengming.zhou@linux.dev
Subject: Re: [PATCH 3/4] mm/ksm: make break_ksm() more scalable
Message-ID: <aqYpx0hYUbcKKVYp@casper.infradead.org>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
 <20260911161210082WKOqK1dumByDY7jeEOdPF@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911161210082WKOqK1dumByDY7jeEOdPF@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 764C8C0003
X-Stat-Signature: f8onea1xi14e1btyqgjh34wx4kz7mhgc
X-Rspamd-Server: rspam01
X-HE-Tag: 1789274570-437513
X-HE-Meta: U2FsdGVkX1+3yZJNr7Rl/Z6YnDsoxJZTrDBLewThUnrXfY/A0UxfpcAwJKu9YopBwAJ+dRdwfZEhDnPZN5dVQ0f/jHjS5yrrPBI71sqyYqZ6PyTjqM9/sQdmp9Mat3xCceWaiV+qBjTNjJctErv2fSRkeKCutpMguIoL1CQqtPep4G2cI89+g+7AfhelOvLbAfYhC3VzcStcc5ngVT/gGZpUDzjTRsktZGEPEtjAVPOyU97U7fBgYzLPUxHpZPWrbCX0MhDV/DL5n8p5ze1mnNNgW4knL70nbyw/hzib3VwAkoBNXApFdeetExcNLAPvoUVusAct4tsKnCGEPdjjdP31MeoNfkua9TJaoKMe4ugm1dQj3maTjKO2Jb7B5t1M6z3fQufvcFAMN6Uyx1ImJQWR8DY7/STOqA9713t++Vy/uaWBhrdm/Mu8P47gTOfN2/5xFY0v7p7EZBCqEUA6OmMaui+j3ChwLzspxARRYI05j0s6QdVv3Cuz/XF8NfryeF3vUx5mDIeN79zIOOWVRybMlX6JKaTovEZI8YgEM6f9YncmxYWGFILUtAGxC7jq5OXeDFdB6tLiLwBe23TQK5Jay8yDVNZdBGD2QMaghS0hLn5nz+AgPN/1hL2F/TbJv6u5e4EUn0lGWkD012SKEoaBL9jAB9dfeV44RCDvQzwG6SPOjPA6GD2ve1jirBEJ8lLT+EtyclTjEAteRPNPOagHXvDr1BJKBIANjbkr1iAjYlFFRSy5JwgxDr88clPYiICCkGIHl1oHYM+CSmmKyNUpc7Y42vu3AuYM16If5YSbNlB5YPEBt+HPPhyAxbKlsDBtQbLtaUT2SRYXj3L2RFu8k9fIQNltixiDNN2pcwj+fzdbQn6B8MqOrFKcuja1Kl+UIgpem81dEg4LTUo7qWMLKW3jlqN5rJRxfPQvVMRHxClimliuphmAb5KfFfZiOhn1MPhZYBgV/IbMPMf
 kB+USdFn
 JDvFWjpi6uq/liqO7mTz11aps/wJC0tVWfSCZjnyaO3d13RnQNW3cegKei7la9gnck/zjVjM3yxntWK0zeAPgHZkme2hIeeR5eCxgmrX+72lLpjgFx+jirg3bmFcWLWFjwQX9e9j63pOyETHhshGjbBMNUBT/NzTPvllwr1nCi71ldL2jsK+YVL2Vg/KKfiUAMq12rIdKIInZSkyDQ77kmCZlevigUtN+T5ljuwalARRqKmq5lGiz6GEEqbs4V3Of3tBFWaPp+s94zBmr+jhvitz0vygrrqsylv3NTQZ6Jhn9Ztz/RA20MDrSMB7XX/pquctecvJv+1e9UQQFVPOoCPftrnhFDyZwAOAg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 04:12:10PM +0800, xu.xin16@zte.com.cn wrote:
> +++ b/mm/ksm.c
> @@ -660,16 +660,11 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
>  	return found;
>  }
> 
> -static const struct mm_walk_ops break_ksm_ops = {
> +static struct mm_walk_ops break_ksm_ops = {
>  	.pmd_entry = break_ksm_pmd_entry,
>  	.walk_lock = PGWALK_RDLOCK,
>  };

Absolutely not.  This is a struct full of function pointers, and
you're making it modifiable.  That makes it a big juicy target for
attackers to find and exploit.

