Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5852FCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 01:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882C48E000B; Tue,  7 Oct 2025 21:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838BC8E0002; Tue,  7 Oct 2025 21:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749698E000B; Tue,  7 Oct 2025 21:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6159F8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:20:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1071D86E8D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:20:19 +0000 (UTC)
X-FDA: 83973191358.13.CD8777D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D3E518000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:20:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="R//HYTdh";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759886417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zD6gDbq1mlKlBjOeuCcGeIUMyY9nJJU0v1y5xtC0HX4=;
	b=UxB60lNDldnDeWij4Uj83efY38LME3SXMvTW+6mv0fYFI/WmkyE1UopUojOflJZypRNlab
	SVVsI9r3b3yoYB7uxzZKl0S89kU+uhSQ8YCPhydu+JGDfLysxZ7ozN25+VMP0vHPrxTL7I
	MRpDdhkYCMYOJe1PBYiJVp+RMcbRw/M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="R//HYTdh";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759886417; a=rsa-sha256;
	cv=none;
	b=AcWK//nKLbkcPWO1Gezxo7u4+YUiNSCD71ZRY4/DZPQCUm/r/HLqZIArp74I4I8V1C6ts4
	MJid6kB9LZlDLjx3gw7yc+r78jubvTF8TdUV97EBmUrS7HqVdauiRSqFjwnQPwa6bHyAbn
	IqqFT1wtz6MecFRmv//4I1+wzMqWMAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47AE1432EB;
	Wed,  8 Oct 2025 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64DBC4CEF1;
	Wed,  8 Oct 2025 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759886416;
	bh=RggMqVpCe390gnGrGEqJRdIG6qG4CtpvuczcXMf7cvQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=R//HYTdhSQqxbhONMMs56VKD4M4Aayke0Qw3/3uFTYr5htKhgRksOzM6PnWOAmm9O
	 ePJQ3W1JyouZ0TN0HQ7ger9uOGa7CuVNayKVJSCCTRwj5wnaXcrbXw9DrWZ1Zhxr7K
	 Fb+ghAFpd2RBXtMscNIkR70l1Ns41uOMUCZ1Ctc4=
Date: Tue, 7 Oct 2025 18:20:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li
 <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, David
 Hildenbrand <david@redhat.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/migrate, swap: drop usage of folio_index
Message-Id: <20251007182015.cae4a063398cdaac71e47f41@linux-foundation.org>
In-Reply-To: <CAKEwX=OfcTDH08VrTMFL-uQyBay11H=NccYWVo73XNHVVf7bEw@mail.gmail.com>
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
	<20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
	<CAKEwX=OfcTDH08VrTMFL-uQyBay11H=NccYWVo73XNHVVf7bEw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D3E518000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: twfeiqr5wqxjotewhcbf86jeey7u5wn1
X-HE-Tag: 1759886417-798772
X-HE-Meta: U2FsdGVkX1+h57+Yoorw6WbzDAyrLr3DhJI3MY6jq55Guwx76Ls0f7QKIWvPZ1d9A+0Ho2y9GHsRv5dO/0ao5x7YaqPBaqm0eYFa2sGCllIftEhw7e8t8jhX8RSnpGlolRqqrDicI1o9Ob8syUKGNKtPg3gCV79xC2XiBImWgkwoGmFr1WPV8tsDNiFE0aIvY36okUtCdv5N+B6KNapXDKajPxW50Q6Z/iyjBY0NCEAYq4moP7xURLwwhDw32AaaNn2HuQQeNRC2feSm3v7OVgS7rG+kfthEDthEMxy8DFE8J0N3fk3lrXmBKUNmOYjZxsTkLQMsVdryUv6NagozHBqR18niOpj8J9ADJZcFdx49bvAB2PK12h7y5ltaODwiKFKN2Ocvtv+iQVeys5gTnZSYi2dWm315CrmyKNYx9mxTS1TlRJ4+7GQKEUQARfwXXPCzSkwc82WuCwVr4jdQMv8pmtd7jrEt6Hllb88jiYo6QRcHkJUQWfGcPPga6sOYDKj3aPdU6yeqeG2WG41Rc3AsTfdzZIFRFE2Lw71E4dmZIBZCtX2qZjg8pz8xIYmoy8Jsdrr9aXGwxc617z69KQQu4WvumAdNMnWJtYCPWxvDBkZ+sSvpSUUGh8lTh/wxOyhh1aPi2fTGfDcV25dmkaTDedyjGlIWYq6vbipFaivxcsdQNfV9ctZ9AvFFdlp3RtqEb5tIrMYUaSk5MdWtx9xq1ENg85UIaq6wW9cp7G2Y1gB3xdsuWK9XyQzy0M+VqjM0UPNnG4IaB5gm9sLapA6TOeA6NiZKBswxL/NZjQ7n4eyDSMnqg1dCMfgSxqRRTB5tn9BL4yJMeyoetwsKKv33+7dq26TL0zNtuOcCGAzwrozDDsqYYuVBSStiNuP1CXuzzq0BlF0/MpYL0YCGJ81TcXz7ThXHAIMFIuv6QvWPefwL8kTrID+GMJdKJMzN5fAr/UJ7n/jRXa8vuDP
 DZg0/HMg
 n4UnMGrk0iVm8Me2WU4hgvFqHeqdjkOZWJQxHmMRRnQ2xioxNkPyQuuwTyXj2s94uI7986QXlm7RIwwJS5117ZSXQUYyY9kX7wKQnPeebiMvTMIobrYVAIOTzeElXMmwkhyZZZyQin0RUUxSg+oCtz6DO7fOEXefCOgS230tsIg7ARvAjxnm0bCK7yC/eojTea0ikmtdLKdL7vx44+88g/0D8e3KTXjhgFpy7E1VlJrUD/s4KouteE6OIpRUbyiwju/3eCn7YZketoDPvrb/vlE/yCErUecwPPGCFQJQPDDH+VNNupDe7f4X1Qm5fNsD7Ny4HPJ7+CkSWR5ohWOVKaHUvTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Oct 2025 16:48:40 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> > This helper was used when swap cache was mixed with swap cache. Now they
> 
> mixed with page cache? ;)

I locally made that edit, thanks.

