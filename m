Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246E1CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F5D6B0098; Fri,  9 Oct 2026 10:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17386B0099; Fri,  9 Oct 2026 10:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57886B009B; Fri,  9 Oct 2026 10:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D32F6B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:23:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C0E2A0191
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:23:32 +0000 (UTC)
X-FDA: 85303305864.16.59641B8
Received: from sender6-op-o11.zoho.com (sender6-op-o11.zoho.com [165.173.180.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id 302F5C000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:23:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=RksHnFXU;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf22.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791555810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZbHmDw7k1JuGcWfTDK449kSL5IH3c8JdJckWZ9HH+4=;
	b=OJkaaFsGMaem9FD0pQRbJ0DGKYWiY5wR1m49XpK0BpWtJNJUVUlz4JOcyysuSvdiprSMX9
	MMGfHuxwHTFc/h/8I62cf7duKOyBA/a5nb34xNg02wSrFZemXAHsu84xEeRkqK+UdlsZ4z
	mY7VQRMRB1lAtYw6y2ncyfnI9OKJlmE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=RksHnFXU;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf22.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791555810;
	b=Lk7sCacT++PDWyGUAoVQbUIRYA/iaNLJI35rUG9T8Vs1ATHptE4dbqdwu+9FAII4IUFODA
	iIIh1xGzmKP80NAGYkt5YbyjOYAvlZcA3GsDAgvWTTSSrEz85VSiFRCLVrVXHtHYS/tTrz
	cYP1fDkkBDmwero8wiqCF2FIio/TGBM=
ARC-Seal: i=1; a=rsa-sha256; t=1791555795; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lAlURLZu0gsFAeLRiD3z03sBeXmic9SGbshdeCgMaFoUMt0T8944Sg4G8+fJeVQ2fSSKUoST3hJtrF9JaYE/z1A2dzNKQ6LkQmiKM1JKkQn5Yqa79C74hElIgHkgfXcutoGE8tzx1ZDuF5wJdl5LpTT4URlDveQccaWZmc4cVbk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791555795; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rZbHmDw7k1JuGcWfTDK449kSL5IH3c8JdJckWZ9HH+4=; 
	b=AyNf1Benc97uLhNZOadBHnrPfdI9qQEtZTBBq/s5SFaqdcCeaUzjO8jNZpLdvTlqFbt9vCPbGydG+rTlU9aZ+YIar8GaXB71wVnwjlnNbuHZ7b1v/RzOp7+1wBRD7AUmg4mI0zH0xdeB3K8rLypoe93rBRAa0eXU79gXVIezrmQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791555795;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=rZbHmDw7k1JuGcWfTDK449kSL5IH3c8JdJckWZ9HH+4=;
	b=RksHnFXUcBOTHXDLrx+PEsxDe3TSlE182Y7go8RfuwdnkyFUYVG7jmGVUmhy/InS
	33+RwaGKOema756oga6ZpC9trR5D8n7q3GnEPq6bqaIs198mef/+pJ5ruZO0nQ6RXz4
	SI3PYNsTn8VbtlMEzJRagi+BUdjHu8WpzNpIT7pI=
Received: by smtp.zohomail.com with SMTPS id 1791555794216331.23684005909104;
	Fri, 9 Oct 2026 07:23:14 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 04/11] drm/tyr: add per-file VM pool
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260929-tyr-ioctls-v3-4-26955fb111d5@kylinos.cn>
Date: Fri, 9 Oct 2026 11:22:54 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 driver-core@lists.linux.dev,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: 7bit
Message-Id: <B980B946-8AD5-48DD-95E2-8EFAF3F353FD@collabora.com>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-4-26955fb111d5@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-ZohoMailClient: External
X-Stat-Signature: iu79hyqt8sxwdt3779je6rka1dya4e3s
X-Rspam-User: 
X-Rspamd-Queue-Id: 302F5C000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1791555809-2376
X-HE-Meta: U2FsdGVkX1+qltUcs+c65fApm60Qs+LbLN+iEq3EieJBcuCPT9xLMBh6Sh1dMpHn39+NmOdN2bM3x2HmOZsZVLk0B1pjXCMN+hQZVrtgMCRv2vfWtOsKkWjSw4fC6U39LHgxU4zGZBh4Ru/PqVCDiEpJfKcFQUzY2hL9F6XW3x2g7MPSHLEf26cLM0cHXdBLnkPJOcNveVhj1aD9dks7t2EXNAFwRAJWcWdqkx4DualHZDLatiWvw5Xp4e8lHPmlLMWmb5Kc8MMZJuVW4MMzn0EdzG+J0SkTgrjDiclYson2oTI5ObBmWUzO52xSABK2srhnymPoWaakGDzPh8EIyzCuXPhCmMsX5IDGLY+OUR9jWVnsqtYnwAknP3ge6rQMAceetqZt2RNOr/pGbFvWyruYi22sxiLskT+JZ80vrWZxRIdLzrYkPM8Ws/a2fkZ0N9ys1AbtM1ABaZZojH+Vg84ynrZq1LVf345tuRSpm6dgin0PKti6Sn/U0pv+NovRgASk4SK4QxII6E9EL0yjtKMLQYR8cP38IvqgEUr+vyN9n4J6SyCPSeL47bdG1E3yO32D5mBjp3lwM6ROzXqRimksAgibx0UH3iyJ39P2s3x6e1sDDBCPbP47GebPAuoxHwjEp/upocUfpKVWtqyP6k1DGdId0bXibaCXHyPkOgR7uI2pL8SxpVSxKg25kRq4W3xCIIXBkS2ZGDX9rfOOJ75f+hvPCRX2pMH08OATOslD6shulqGpEUu8B6/2DvkI142Rug711dARXc2CApXafqg7BmG+iZUq61s4SPqYW6Ix/KRIIPoQBiP6f8sSqODURzcuP47hENpcHiXPyUjvpC35HQw3r7SHn67DzZzlHVz39IjBeCBcinzBvxZk9HAkr85CNiNNCe4cCxZ3McoHRYy2QxLhGGIfXvg0CdkGFmac6bo6PgXEDu2G93/2igc0KaXoMdM6Bi9Qwtw9cjK
 WNSomVnW
 WQIK3GkVEztaQdYQLDasNi4SZ6SMJ0T2MW47PRPQZ4AAxj3DSJYmqXUEl3L8JIlE/hz1KByVsr8AnxEt9HWFEiHrTsBgBLsrcZ+B7DqahQoJwCRX5TASBVkOt4zbHGDhRCcRdWHRuriNr1lRkvNTdIHiDSjL1JsuvmG1vTpzq8sK9im83/lxA+PHBWptAkD3BMDYPtD9ysJDYdAIUI8I7ao9OkEqZ65FkXGm25SpIO4T3CTY1z/ByX6TcsPwpZHlw4s+rePmSe3OoDaQgfC6h1AJ2F0yt+Jphe8OzVK42d2XCOpc3l4DhggVnOhf3Mr8tD05ghRrk2Ju9pQxY9YxMZosPmLQf7fNsSCHost92VhrxfERfTpY7lekPPH9XF3GxY6M+REmqiOIjsbJ3YO11CpFtrKpz6k3LYSbM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alvin, thanks a lot for working on this!

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

