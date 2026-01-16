Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB072C982D3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8566B0088; Fri, 16 Jan 2026 10:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166136B0089; Fri, 16 Jan 2026 10:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A276B008A; Fri, 16 Jan 2026 10:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA2336B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:46:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 253F41AD86D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:46:51 +0000 (UTC)
X-FDA: 84338255022.06.FC0EBB3
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 319A6C0011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:46:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1gYdyWOd;
	spf=pass (imf28.hostedemail.com: domain of 3Z11qaQkKCB44FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Z11qaQkKCB44FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578409; a=rsa-sha256;
	cv=none;
	b=GlBi3Y17Lbz7bYn7CA+a5BbUd3glfozQJ8XS+ur6zhyuEmbVchWdjjgDCUTBAU4bjZSPj9
	Zdsx0R6HsxGZEZmlzqLbyp31NEaC+GQ5Nd5w6suUfSsKDNxgnuzcHpv1CiRAKxbJnjoJ9q
	pugI7PjlKPNs/KNFsLabjOgtLA5Gw6U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1gYdyWOd;
	spf=pass (imf28.hostedemail.com: domain of 3Z11qaQkKCB44FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Z11qaQkKCB44FC68LSBFAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C7r39NKpBQyuKnGQ/TDPTBGIStYQI+zyUw1P+bFsh1Q=;
	b=KNp4M/80KjG6ucZPVJo15/g477JMWWMmNdZZxvKv3X/PQoJfB+m4V9CvUwqZKTDS1iJ2ka
	Yt0Ug4icW2AzBYyeYQ8IQg9ED6vNnpeUG4yiliP8SlWegdg7hizL7ov36RybbFnISObEca
	oKn8uh1bwLAzC7FmWQg7QdlauG2Cab8=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43009df5ab3so1692560f8f.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768578407; x=1769183207; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C7r39NKpBQyuKnGQ/TDPTBGIStYQI+zyUw1P+bFsh1Q=;
        b=1gYdyWOdwuq3vA1Q+qwgXPJUvyaqdweUQoP6npGkXuxL4VH+1HR3xXaTpS2hOTH1ZP
         64n2Xm65Y3pRa+4txx2vECvx+D8EBjtg9AKZy5nRjhrHfG7zoYLmwfjlVXZlp9s8ua2M
         U/Fqnswj6jwbEut7d+bgc0DYUEI6Mb1WeKo3tsUqqk4BAG6eiIE4x7hmOGXx0z2VTphp
         jqEuRlVhAxnx2eK4bnyXPa02qp2C8Relwj0aFRCHogrhiejX8KwC0Fu9rke+2x0XjcZE
         /gHjWZPBDh+m/7DAbzgDejHYK3AfIB9v8kloiW/q/qu/ri+jD/M0rGMxOkxAsg2DBicp
         KEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578407; x=1769183207;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C7r39NKpBQyuKnGQ/TDPTBGIStYQI+zyUw1P+bFsh1Q=;
        b=CJOKcGxZC53BGT8mcRd8btIcZCwPr+E2u5WutYagSrpsz8jRrtcJ6NPtEv0SEnMex3
         ni3JqWbsNqjBS8007Aeuy7pflssCR1WcjwsO7quU0JOehYqF6I7NZlBl3xtWfUNFY6IL
         nTG1/nqfbutrWSNP+ytl9etl5boO+vdjzCRUJiLqppIpZJQ8SQPuuxXMiiRGHsTN4+pP
         KtZW5FwGgfHEoz6osEQg2rewrZzV+Fttym9k2SH70GQ2hGmlA7l9A1ZPaOkfEuy+I6my
         tALO6BdXwYoqVGF3sczkiygWB6hgV9c6hIHC/sXvziAnzpUsiL6qeKdNCIHN+DCmjz9u
         LnyQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0ObBjglEYOQ3BAVGaSzb0JooyI2ltOGdxkUdyMWB84yYcLQGiadsZ2+mGfjmpq5hUWmsgdOLmAA==@kvack.org
X-Gm-Message-State: AOJu0YwGc9tZi7Wgi5x5h9+opjdVq3dkcLAN+1WK6YC8j4FpIt8w81SW
	PFiWZZGxer2YpZniiGnlxHekJQVwFbj5AJdlCkdms8XocmCrrveQo8ahyfh8h2wAhOtbD8G4nJq
	VXtpqJYpZ5qdvy+tA8g==
X-Received: from wrbeh5.prod.google.com ([2002:a05:6000:4105:b0:430:f9ec:6c09])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:24c6:b0:42b:3062:c647 with SMTP id ffacd0b85a97d-43569994133mr3828887f8f.21.1768578407156;
 Fri, 16 Jan 2026 07:46:47 -0800 (PST)
Date: Fri, 16 Jan 2026 15:46:35 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFxdamkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQ0Mz3aLkUt2k/Apd80SLVJNkyzQjQwsDJaDqgqLUtMwKsEnRSkFuzkq xtbUA7/6RsF4AAAA=
X-Change-Id: 20260116-rcu-box-7a8e4c9f2180
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=942; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=Iz940EgkLfNNoe9mfYJ7T2Zz0bFCqg1e5P7kXk7aajQ=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpal1hu1HSF3Q+msN6rGImAxNE3it2AkIevWXWZ
 /iru81gV6+JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaWpdYQAKCRAEWL7uWMY5
 Rjj4D/9SMN0PJKBXhY8oL4Xia0Ru5guIiPAURyKUMkoBD/KRxn9D5YQ+be/2XdYHMfTdOrtDtP+
 AxfbKxlp41W0cnQFpIDdduf95OJNQMb0K7gfKQkAp+oF0oBn4GJQ8/6xHXaj0/w79PAH3P/5klR
 k+aYv52qWF22mgn+zodlQM/pRfLHk4nsrlM4M1o9YpX/aBNZn4GXcSLVVPsmHILAYmiPNPZGk94
 /od1Vx47vl2EBogv3K1VOK+K7n8jB8ZdwdX7y8tOfgCLfB+zYUueMMtyCiTWIVRb5yxtoXsWckG
 G1u0rRrm64ruZohLrcbj6nQPkVb1pxshdopXezmTCHXOWYudESr70W87vOkH36oLSwuSkGNn89C
 LDgf5wKklUE6+AumNylI4Z19jTQqIdmDqI/KFwwf8HKlgxvh95z6JHd8gcpNZzlWM2l0CF2p2Xi
 K0uNL7zpHTpIATk5FWxXkBzU2PZO9aajB9LmwBI1h0aHxvjm7acX6ZtfslcL3SuEApheQCqavd8
 4PY1Kd60fil4uvVvlq+Tie7M5mb5b3kWRAGtl/ka85tN0dOne7Vk55ruq1G+VHCEPZYkVR18cf6
 GNJHSt/DDAlcxyO4DT4+zSXzv8P8ZcLB9JJb7Wg7k3754lbpvY4FK/C1f5IQkYOa5CPgKfVD7bU PCC2U9FYULLdvxQ==
X-Mailer: b4 0.14.2
Message-ID: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
Subject: [PATCH RFC 0/2] rcu box container for Rust + maple tree load_rcu
From: Alice Ryhl <aliceryhl@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Andrew Ballance <andrewjballance@gmail.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: bygbptjgeptchkeh66qma993i9cdpori
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 319A6C0011
X-Rspam-User: 
X-HE-Tag: 1768578408-544175
X-HE-Meta: U2FsdGVkX18C1J4zX+GEm7BYkvyc3IUIWncQFOsNffIS6l4uqC3P1okTsFAuc8bsi0qAbJ2OBpyk4AK/tgRsw8avAMAn2NJtciIB1mdbb7QINzggyZ0bnaR3e8urujRU89jViNoMAWvvZOqu18baN3+UrDY5KnDt6hEog5E8RZRSNYGBk+qpvwrRMqbmQ+NV5GZPOBoGiWxWWBM9Y2v/dy8bzaCbhH0DPuChCZInBM3X6XDHltHID3EbkD4eKB5kUO4RXyN1qVI99oo//PZ4Tue58cZWWjtA7PHsCDsL7BJZivQ5qgNh9m69FNtfxiHV8tNHct4ZeN5BOPGMgq4Z2DuuPAR9xu2sw3Qr9HnkqNhYwZ7ZsWZIH4kx6B9166pfJuNZ2A/fuzeVNNGU2QJkpunLgIzNOywT7F7kjOFWyTqDbt+Tfl5qkQdockV8CdKnYi+bTwMgqhdh4KfgLMXlsvW0vZw2hkjFn+89ZvDQuWjFqG+UHiwAbgPGF1iSbpO4Y+97no4SG4iaUDG0rGLDxstAcRoJhkCLR7Gr8YWUuHVyJU/8B0MvayXwg9X5Gwk1Ol/XiG5fj0Apz/tKocM5mvCJTJCz39z+zT9/00oNwSTMTbTwEQsJsxnLU4iGwVvN+XuXCNTvJYIuwbWGeBIXafnO2g5YI+6YIknXQLfnPormPvMNztHDQ6RzLV6FGUs2h8zIQmQh0a20xWDsxR41KdpjDp6zRM40mPgPOL5SD3L+hYKJK4+6FGu2dB8WU5wY2CC57n+FTWn/SC/NPsK6lC/DiODiSmpxBWk34awA3hClIzOR90C4ckc8xxXYuuYNo82LVvy1ccW3r/vxmp0+5yOjF9mBDUAFuRdTfHBFwKHj10rYcOHtmL5KSFgFNeSHdiIhkor79SZuk46G/oFIMXDzIy1b07B4cNzFWk8Sun6if7TBuyBOnLgDF16jHP9dK3EIgqq32kBqr3h6en4
 401d+FiG
 QKq95ikvf0IqsSkW8BFNGn9tj1u1EHUF/0lpfJFsnFVWsOZAB4RIoZD8PExzW4sptVRVU/O7u1THXNxE5J6SD8h8yD4NQK0P7sDRyb9j5i4bh26V2BO3mxZri7Z2ahEIIOZOPA7xH8FVtDH2QVAiIFY9m9ZtWa5ubK88bcxqSgURNS7oOp6kEe7f6USG3na0DDLAVjAyyfEP2z6hijIyy597eX720S7nMRRxTMaCvNtLcyjEmAvwD3YvjHQDxa+1NRhczt93cfT0tBI39KlKBZCJ8ULFjBHvSLihaw82TQo1WLUEv5omNMLVBKH8cEpkWMC1NVIbCexG8pH45EVnYfKmR5U7P70WNgxwtP0qUm4AlHlnGjLSsDg1jOfN9wTjH8TuZWAyNEfMDWJvzxkn0wM6Rptv8PCjHg7qKcvHP65ASGR/6iMx2apLpTKBpobIskJvl3fPy8yt3xGKchW0ZFHrQPvuSYkQgnepxwO6xFJ9WfffKx7aWUa81Wpczr/Fz/TAYhUk37yQdGM7U+NwwRbQwhF86iZeBuYbdHgZZlsFbXkt+ldR9HoDBmAfETuxqEfmACkEZLxNIIo+nbWFv88YeC0G47XArJuUqli5RfBFQ9maTRjb8PNagYwRslWtuvBokucO0lXYheoMBJHak1bwa2N2MSF0yNQExUKyVfw/5u/Fns/zpcVvHpPnvEOhm4E5M83SNRECyyr6JfDmNZcTzEBUuLduohELnLSXVhN8s5GSgwUoxr/q5eiJylqv4eYtg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm sending this RFC to share an experiment I'm looking at. This may let
us replace the range allocator in Rust Binder with a maple tree.

An RcuBox is like a Box except that it lets you obtain a &T that
outlives the box by a grace period. It does not allow mutable access to
the inner value (Binder would probably use LockedBy for inner values).

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Alice Ryhl (2):
      rust: rcu: add RcuBox type
      rust: maple_tree: add load_rcu()

 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/maple_tree.rs       |  52 ++++++++++++++
 rust/kernel/sync/rcu.rs         |  31 ++++++++-
 rust/kernel/sync/rcu/rcu_box.rs | 145 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 228 insertions(+), 1 deletion(-)
---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20260116-rcu-box-7a8e4c9f2180

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


