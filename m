Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE92FCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCFD6B0095; Fri, 16 Oct 2026 09:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2F46B0096; Fri, 16 Oct 2026 09:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFCA6B009B; Fri, 16 Oct 2026 09:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9963E6B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:30:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A208D1604A5
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:30:31 +0000 (UTC)
X-FDA: 85328573862.07.4F40165
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4E9E140006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:30:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vz4A/w9k";
	spf=pass (imf09.hostedemail.com: domain of 38ybSagkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=38ybSagkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792157429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=38bbwGsSQzV2CEajfwFdc0TQEC0G5ZgW+cODzujfzU8=;
	b=oChlFaYeCbrwjo2At4asZBPwpI+PON/UyZuwkc+HmOATj3sdoqUZyipgxlfRd48P/QpRyV
	bI3GM6pn4GRWdkgtngjndjX0awk3VvBgv2Ds9ATAJtm8PMb2TQnMSEnWCHOc3O+649L9Uv
	62f+TPNOgufWnJOU+xS8pFUnhO3nZjQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vz4A/w9k";
	spf=pass (imf09.hostedemail.com: domain of 38ybSagkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=38ybSagkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792157429;
	b=6w+f///r/Vouwn1WsXtZtXf0HT/cxdKqpBz78u7sAwOpsR78LB6HLrbFkFV9M6GRcT9DUn
	27O5LQLtJU9MlW0qEXOf7luoSfQy4koDEpJwimhcTGMVQN6Wn/qlgTCOhSQOE0B6PC7LGI
	4sSKT7aY2PHCf7dXA0mZeW9M7KFKzLg=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b1aa4d7162so6945997a12.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792157428; x=1792762228; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=38bbwGsSQzV2CEajfwFdc0TQEC0G5ZgW+cODzujfzU8=;
        b=vz4A/w9kS3MRyL9v8KSvFkehsFvt0e6zvi9v7eU+ZPHENPFgLMGk/JqzJlkHF3Fmbs
         aC+udSJBiq7jgRotdl0TeLGmP55JnCF+o/ctshFJqUtx5MhpyFbw21Ntx6RN5uMyRx3d
         r0268AkHSRWBY9H+QhDQcM9GyTgPQqm7cLfnVZ+rkxSj4kUhvZrdJuuZwhHtAH3En0Nh
         GvRBuMasx8RZJ8Tle7lz0fbGHnSZ0CqqQsr+kU9G5y+JROvKLV2ZmsrXUtjtOfZCodPH
         jVWjnXRjPQgDEmYvpDv2mJM+g3vU5mLDdvt0aKLjkKfDhbfNybv8iH3RS4Hxpa9BMQFv
         ZWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792157428; x=1792762228;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=38bbwGsSQzV2CEajfwFdc0TQEC0G5ZgW+cODzujfzU8=;
        b=MAt0AJ5XZ1q9MFYJf9LOVQUGKATgLvA9JVpjt6wS0hDJWuD2ywSM9+ZYzlaQrASElg
         Urierf10wbzlJky/aCS6ZKr0Ab1hkbv4pjqCnhffK/l/N7ZZw8tlprbHTW/8EktoEQhm
         CN4zJu+IKA2Inq6/JEoh7iQyS6+Cs6FMDHg9P4n3qy0mam+Svza4ax2enZPiSxzHcQmr
         INcUL8WPb4o8J5aOw22bGTG1NK4sCEYKM0XFBQSg1EjCFddBL8NObpu59aLtkT//9wL5
         pADiYMq4fpz/Nsf92Ft8x/x/JoIQ8rq5RuSIyPTKYGA1SyoxGR1VIr2i1bM020p3y7yx
         trMw==
X-Forwarded-Encrypted: i=1; AKwUvBw5jLGvU0gtarKgttd+1qPy1Y9IRIuHSUD/Q6oLm4aWcJg4Lmi2sjK7twi2RoDbQ08OPJEkWigbAg==@kvack.org
X-Gm-Message-State: AFq9FYJmFvBrndzl8+gYbypKNzzCoBF+PsCVGE6a1vjfOEM9EcLLhrmd
	BWoMv7Wup7LWS5+zLg02f4hU4v0Cm9VenPHh3eAwx0HFFL9T7ESpMRDi0cnlzoxbjPQggeqnPpO
	DHj9dogMnw2Es3iHQXA==
X-Received: from edbbe25.prod.google.com ([2002:a05:6402:1a39:b0:6b1:d06e:c413])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1cc4:b0:6ac:8dce:5a86 with SMTP id 4fb4d7f45d1cf-6b17c257af1mr18581683a12.23.1792157427717;
 Fri, 16 Oct 2026 06:30:27 -0700 (PDT)
Date: Fri, 16 Oct 2026 13:30:15 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAOcm0moC/x3MQQqAIBBA0avIrBNUJLKrRIvU0WahhUIE4t2Tl
 m/xf4OKhbDCyhoUfKjSlQfkxMCdR47IyQ+DEmqWQmpuKXssPGFykVutnDVBCrN4GMldMND777a 99w8wqDVzXgAAAA==
X-Change-Id: 20261014-binder-memcg-b42cb9f1098d
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=897; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=VdGSNwvOHS4tbe2yVTH2LkOvCQHy/DauMn+6yQ5pPyE=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBq0ibtYNvqiedt02F19Xor2K0bMRzbl1S9CHsPm
 jXYYOrb/fuJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCatIm7QAKCRAEWL7uWMY5
 RjboEACMnNKyBE64K0GQYb2U/3ziHnVZKrSyF1FRxjJgNj9kH7uTZQ8ppQqBLuwdtyzRUe4TgJb
 WyCVeLSpXbpIZCLnnPjB+wxyUFZRReR9sB+q+FzXkMWJjvZOXh9MKKuw1Akc7ilP3YdYxCynYFy
 Qnch1TKxg8vw1+GxPE8q299F+S8EEEc7Yu8Qua7u1C7qzIF1AgOW7VeIl7E7P+tYiChWkFwwmMC
 /DoenxAlslhnK7HJnHDga/SV7bYToQDjsQ2JuBRNQQvo9P1QWSWi7YVlga6uVqS1ZjIcDWCaJss
 6AMv/CTO3zLd9W4gwckIc28DhalM9zEECBodjRbAEAxYxZ/oqLcv94qeQ2Din3jYiubHpz+dDem
 2WgrO/KrUfiCdhz/YwLzA4ls1WyvxX3fZqebb+/rbHQpthzSAECFtFbplXu91dgVlIKxaIp2U0C
 HdfjvhyM+PP8X+J9043uO5n3eZZQxy6xp4XzpSYEmp+V8AhSd4pK5CH3tmomiqYOLQLAfjxNu4R
 mkqSO7aUgvvXYDGIcoUXq5zL/DlWdJGdJqZyMiyqAhbE6I+xV9v8l8AcjbX4e4dLJaV/0CyaEOU
 5eW86eEKY59W4YFIxyl+xyWK1smF5Fkk7mwciIw4gL3xiCg+kWh7VOy5M5RVxpFeGHGAOWVQ/zt yITc7uqoXonPx/Q==
X-Mailer: b4 0.14.3
Message-ID: <20261016-binder-memcg-v1-0-d659b8ae088b@google.com>
Subject: [PATCH 0/2] rust_binder: charge allocated pages to memcg
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"T.J. Mercier" <tjmercier@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	"=?utf-8?q?Onur_=C3=96zkan?=" <work@onurozkan.dev>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4E9E140006
X-Stat-Signature: jf44n1sbahwgw4e8bsm9f8d63mnkpu6q
X-HE-Tag: 1792157429-193618
X-HE-Meta: U2FsdGVkX1+x1a6jd/dsCucYcDolqs70qXKjRxsQ73vHn044+kiwDn2slWshVI/YGhdJzGbb11Q5vTzEfIDlXwRWVXYuGIMX0e39UUAdofns94Th1IFgY9tIpN8PaEDOG3VsmMBJDOXyF3nBNfnTydMdH5iWxcN50Hg/GCwdz95/ShM+u83ZrSuRynBfgXNjDtk3EACX4Drw3NYSQ/VF+09V2sAGWMz059xwld/eb1b/mN73leU7yWiAWr4w1+s8lbC1qU1S1E1Ah8Dmpa76HBCFFNBaO391BsfFog4lwBELOZ0snfGTtbBiNkB4CKTm69XmOKKzR92g5/dgHH8u7aQajG7BUjdl0rEPPOiDIjopClxXEGz+vOYUl6i8VgcPl/WG4NO3V9KKUNYRFRsKb7/lW75JiiRz6Ip7JHq01k+ug3shJQDZHEzVqutOg74aLhP07hm1bSR7uHhkpF09NNi2sE4Z8XuJUK76tLtxlc2+WAWnQzH1OwkuIDwee9SvyC1Ds9i5ME/Fdy8I6p5Suv6HeeZ5BBGYb2UdsNB0bn+G2GF3/XltqWSLVrXhWZ/PfdLJLixqtE4d9uAFias7BiOwHwcu8WGx5Xko53wZeNF2TWqERo9XqNo6irWbLXrpc0pxOPx0+kOeFC6siv68LDmtnEtR4RTWlXpqjg3l4qoM++7eDfEQWY9PilXrLll0sGUe4CCGLb/cTbx5z3JpzG0OKKyV80ctiFqOaoVgDGS5vJsmxkVwTUUr1CaF0URvBGuHuXprGT6KPD0YeCaOGdbtLxP0+9hRiISmWTrwp4yDI+ZlRTIrRpuZw0F0pEoCehQ7fsPPZ/bTHMiWXE4sdiTH+kzKPVvOQBdavQuN+vdMdDWJvkvqP6hBYMMJhUbJEJqyMYawlc76sZfvS/nKm83txGzx4u7nSHc19a9RpAZoXl8/Yl7NAJnoTv+dpayH5QomulIFTITJhNraC0r
 LqgFhP8X
 b7X7j1c9BtzPz5Oz46RXP6nTOGcAstqUlRHMEJs1fElS0ZEBBFsTmJ9HRGoHXpeAqXM5qVb4C4JoDJbSshzN5HrTJoTSyVB0CMuzBbBw0PDDAzV4cJe01a3RxCqem3v9zMj/r2zjmTMYwJFskd1jld3vnuY4+Lr/N32KRp5w+0axwPAKCrytfqhJHuC656GNERzWcOtugOHc+aN2DulW46p4dW/wXF2Mbx5+UofaRIty6NhDrOVYQ7oEuHmxrHh3tpy83gfSugHVBys4tqFPb8Ci6yeB8uvOQoIqwlKbeRFdjWuwTkiEdg8zyyaxAXLtglIT0kk+Ut7k+CaB9glf78jC/D4hb3W1/8HZ5G6ljGg78fjsSRel9ODF872vhKMo8ta4Jg2iL673D7KWMXxtBAdyW/NXaVgbLR4ci2IaXrdDYcjYB3a8nPM7NMIFof7BowbA9flSxPJEpiJGI1T97bh+NNeftxN7IHfdWpVh+jVzoKkBsIACpP75a/JYaTXYh+WvVbMzOAIe7y7wFXGzShMsVlL8USZ9j6cOHe0E/bM6KonLdMGIBu424y6VTKapVX33wC5Mfc6ZzhmjY1RylPTbc1kxdfM1BgRkIxhQ8coX0HsnoneHpcohAxB2lqOJTYwceAqUvfQ7HF55zjS0oo4NKjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages allocated by the Rust Binder driver and mapped into a process's
VMA are currently not accounted to any memory cgroup. Add
`Page::alloc_page_memcg()` (using `put_page()` on drop so folios are
uncharged when freed), and use it to charge newly allocated binder pages
to the target process's `mm_struct`.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Alice Ryhl (2):
      rust: page: add Page::alloc_page_memcg()
      rust_binder: charge allocated pages to memcg

 drivers/android/binder/page_range.rs | 13 ++++++++--
 rust/helpers/page.c                  | 17 ++++++++++++
 rust/kernel/page.rs                  | 50 +++++++++++++++++++++++++++++++++++-
 3 files changed, 77 insertions(+), 3 deletions(-)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261014-binder-memcg-b42cb9f1098d

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


