Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C67CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE22C6B03F5; Mon,  1 Jun 2026 10:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9426B03F7; Mon,  1 Jun 2026 10:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6D96B03F8; Mon,  1 Jun 2026 10:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE6046B03F5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:58:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70416C23E4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:58:54 +0000 (UTC)
X-FDA: 84831650988.25.03354DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5866140015
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:58:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gM15N3mX;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/IpOdtgbKIAl2lBIvOsqwpQFQ2lbotqYbZ0uquPqG0=;
	b=dO2ouULQH8JTBAKVEziY4BbHP+xmUqdGXpqbbzNCGzeA0G1p58BDvTurDtM6R+PjJe4LEN
	EBhXDBAqxRzMD0VCp1fT6PcSu55PgHhBo0UzzmCRUVHe2wElq6LXxg4KWjcfB3Y7r01e49
	HbQu56PISmAzL/FJGsh2PkuggZB9WH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780325932;
	b=Gyf0vhoCsIv0VuD6tH382omdK2/E3OQkdrt0zHXeK3TF7o4wVDlbg+cDkGCZNxtImEdeuU
	UV/tzx5eJJjXS90+kkyYh9skGDxTtP34VkHId1ZENAgCp8yXvjPPa/8Csod2Ic1j3+RtIe
	P26Uatj9UBtzz5wCBUCit50Ciu0wXDw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gM15N3mX;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1D2A40207;
	Mon,  1 Jun 2026 14:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8173A1F00893;
	Mon,  1 Jun 2026 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780325931;
	bh=R/IpOdtgbKIAl2lBIvOsqwpQFQ2lbotqYbZ0uquPqG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM15N3mXxI2CwaX53/dDJnjLxOmeL6ZUOw1xsN3O4J0pJ8WEUx8wSXel+u5aeP9o7
	 ajAibzrwSgw03R+J0jOw8AthcZtIagDt5R2e1OKX1aNovh/tCUN4j5D8hEgXsG9sta
	 oZblYAG32oMb301wi0CDjDxqdKpySVfxb79dGVluRwJj/UTkiyzgtkOPfcXx6YjwVD
	 A/Vf1Wk9LhiPHXduv12JSH0Lpuk3SsfXEnJrkjnpWHfYb2B3WNn3EEdCuC/vZiO2sX
	 tyTmg7UblgR0LnTh1zTtmtBu2FSCkiPpKeS7YP278FffTFMar5zGg85HZSayYuN331
	 8n9UX2OOUiY+w==
From: SeongJae Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] MAINTAINERS: add ABI documents for mm
Date: Mon,  1 Jun 2026 07:58:33 -0700
Message-ID: <20260601145834.117387-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9271c3c0-0b04-47f8-adb2-83f5f89674ad@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5866140015
X-Stat-Signature: 6ao53n4ihwzqm7tf7ka3apt9g3nyedsw
X-HE-Tag: 1780325932-331382
X-HE-Meta: U2FsdGVkX1/UoFoiUIJNGF6aKcuSMAabBt3hOcZ6ygTNtZM1j29Qe6P3MX1EGRvAGcvMSe70lEjR3dKRyuUJYfUo/6N3YUnSqYu10zbd4kVhDH1sxQ9776EDt00KdERhik+WaPRpJzWVjXMF9eJU6zSLi1AG51uwTFM8qBBeeLaeMHFztCDrR7LD3mHuXk8rgTKHvF2KB9R7adaiIafwybKa0klFY7fX7GJMWts8CcRmCJXsKeWs3qvlNEK4nAgEggY9eM3AKirOJON++sXBjIuDuLZln2fq1yh6CJYb3M/EYjQYlNhTIX7xO29rq1MMcdrMl0MKdHNaMhuHBs5JcJuWMMxnMWsNdf1hmtlBYyPBMRdAEAgAR8WFSFGN3zoKzvRVl68m/pS4ebah/6G6V5y42sLpHRglOj9KH9yKZLsNvNf7TES/u8bf4lCaToGRcEoraMSGHYnYdKA/BYG3xk15xY3gS9hu7EhW/7N4eHFNkuwNCW0nkxMIc6OzzuRQ3Cy/pxDZFp2vdFy2v8DPRAfcILu+axYwiDf9IeayoEnZkmPMX8Em4Z4bWxYzMnVJpiOFrwXNoZoqGy37+Q049Ixj7Sod/qSYv/Gyt5/GS+kUupLN2Y5HU5R+KLsqFmg4k9qAuEe4REBGOZaKeQJjLbc6BrVpMBhkTURDVyvu6Ud8ZNPs/q9vvvDYTMNl1OJDlG/vUsEAiiCYuFEwFi0YyoF//8SuYhtLtlLbrj3ed/59vjcwLf/QUiwrZOFfMqPtIIud1T7uJ6rlmvUJJ0QZwl+7ryiGG5z0ebnASSNSwjG0z5JFC6nGXUgjpDbQ5v9d43D5KtvQTZApFJ3s6JgE2UnT8hRq+FyeYXlI5OqvCiJIT47B5UeRZPxTFUCHOWBzmvflDaQy6+oSPJT9zRcIr8L++F8Pep6DjZ7ZZyLAkxcEGKwurWpG+qQ5+k6x97qdcZ9QZmgUSFTbcYBWPV6
 A4iulTkY
 MOnvNGgQX2VkY0K4DKLoGywWOkhbSlOELKZ5qZozOrgFSocZk0GcEBMuVdss5NnVetGKYorlz1+D3Nluq67j8/UF1aJEkbfIeewctv2qi3YX0Ti7SZkZeadZcno9Qq/5ZPpiIlI9k4C5/QtsibO7nKwtocuPUubW9etTlqgl5AQDiiQ3C9l+jfl3QUQKrUQLPxzjUXPF07YNQBK/5MZoN9nD82AQlkrS2+qP9bGnaX6AePOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 21:19:29 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 5/30/26 03:18, SeongJae Park wrote:
> > A few mm subsystem entries in MAINTAINERS are missing their ABI
> > documents.  Add those.
> 
> Maybe spell out "testing ABI" in here + subject, because I was concerned there
> for a second :)

Thank you for the nice suggestion, I will do so.

[...]
> All LGTM.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>


Thank you!


Thanks,
SJ

[...]

