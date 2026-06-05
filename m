Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD013CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7B86B0088; Fri,  5 Jun 2026 09:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888806B008A; Fri,  5 Jun 2026 09:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E2B6B008C; Fri,  5 Jun 2026 09:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAC36B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:35:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 179E2A0115
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:52 +0000 (UTC)
X-FDA: 84845956944.22.2043471
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2FAD5120008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:35:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ix0DkSQm;
	spf=pass (imf29.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780666550;
	b=MCe/qAuWT51L7iftATI63whZ1bMa4Vx4DIvIzLpm1FdKjnippHS7AOrLtT/ZR2J9p5hh/I
	55hWvBILIG6cylHHrrzOROtJdeDAte0x0/F+lQcqdU+ZFyBULOB/A9tj2Zdn0orW5WNQDS
	kmUq/D0gkOoFdYaWC1r1SN7lH0COMJc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ix0DkSQm;
	spf=pass (imf29.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780666550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V+3GJsZxiITcRMlzwywosE1kBJjYYPTTK69C+X92Rrw=;
	b=vkngySKLx7grWVeEjff7H5McvNzj0J6QeJNJneW+/21jRKF6w5CNnivmKeQT/c1rXXQu+/
	0f9bkzpcVYInFFxjIo/4CeDFDXQFG7haj6LyhOsuXHN3vNNIZGu8b/5wAXX27XYMGvw5Q+
	+iPKOHZ3q51BT/VGAENQBR1RL8iAqak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72D4C601E3;
	Fri,  5 Jun 2026 13:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B731F0089A;
	Fri,  5 Jun 2026 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780666549;
	bh=V+3GJsZxiITcRMlzwywosE1kBJjYYPTTK69C+X92Rrw=;
	h=From:To:Cc:Subject:Date;
	b=ix0DkSQmUGurOTrxvkWU7LOARXXBDSkm795E34/rofpJEaIVLHvoilfrBKuy8IG/y
	 tVWylKmQxvjuDwM5oab0kE+V+t3esDnq9QJlPNhHH5HWipiFXxBPTa8a4hfr2KzMDd
	 RAnh2YkQ/2uI13MwrEgi11yDrZiI/Xq+CB5eKL0xPYpcnB968/m+8lv4f/XBFyoKaw
	 J4br78NOtXfKDQYWJRTZ6EtuZMglshD1aA1MqfH1rbnRycup5iAOBHXh2VAAKtG3SJ
	 FCsmX4njD1QrkIvji3K1JGDV5nsonJy7CN4klFGZj2BrmfEJLj+IkDSoYuy6cKy//E
	 ZtwyGIypkoEig==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5B751F4006F;
	Fri,  5 Jun 2026 09:35:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 05 Jun 2026 09:35:47 -0400
X-ME-Sender: <xms:s9AiaradpzQawOzKlJVdLrR4MQLkpLTE_FbiMrwK4PtwHVH_Qy5Vrw>
    <xme:s9Aiam0rZx6Vqij-n0XJQMXbyll_Wv18_UYjL5Pc6oD_1DKFgEun5JsmkyKRsLgDF
    ba5z_9a237nYuDO5K7KEU1zrsxyLGKSA93STKOyVKhnUnNCZXk-JtQ>
X-ME-Received: <xmr:s9AialO2SzzCUNoUPS8MA78Q6f4GJkThBBPf1nyzR7DSTjOoRX4s-kHFkvM>
X-ME-Proxy-Cause: dmFkZTFKENnCiyPS37jOfUW/oSt3ApI4Om6wyeJiiPYsBRF27Y77NEp2GRWEH/Wu22F/nN
    jSLPXUo+vpn9G/MZoMnCSmi/RsIDJMGfJOTTMeMH880odghXtGPynqv6EEGLiWUW12Ktmf
    F+PPRU0YRdVUAi+LO4dYxUc0b6J0tg7+Juur2hWdNU+gehj5U/NdtzZkPNhXPF4Ah90viD
    aqhiOSGPff6V/LBAdW9kqJklU4xsIoTyQSGu0+i9A580vKQSwad1R6zoD1RnChJ5FNQ0dU
    bczE0+CcxhZJZhPPbEA3Zn2zVHH/I+liU4sR06uQjZ7j0Fz1fxA7p/zOJ9UaIcNU9giYU4
    XnFhxWfhVpmI0x48ilXTpAWnWZJOWYHCRkUPVu8DzmXQd2Evddhunr9+jUv3n1xsRGUJ1h
    KQmDvz7AHx4jreqF+CU8EJa22nDQZyEc9Isrzx55OoJPiCds42Ma8cXKeCFslYjHG0g2UR
    m6MN2ENP/0QYdd3tNgHfqUXI8s9lbQEVkiZm7rEvQKJcZd9JW2V8zNmSlmmZOl++/Hc5au
    +QVxNWcUjE7N0iLrQMQT9DTEs0O5zHvXQelb/HgeoOaRMTqiwWdtOm48B35HA/2VcP5yvX
    S1vKc1wSal6Sc4eAgayfqjlzetTHUH/A4qSt4sbZEumI7lZ7JRGIbnYqaGjA
X-ME-Proxy: <xmx:s9AiaoJP5H1mQq9mKqc22IPHCNQuAKSzFAZYMeMiGwLs8-ig5fL5Hg>
    <xmx:s9Aiam4LYBXuxb1CczLm-kQ0FUaaSPEcwlsLr9L1gFUdmjctsaDyDg>
    <xmx:s9AiatSoEaiQxwJIDLjzp4xVMegWPQ5UQXM7aeL9Vst0yqyTkKrP3A>
    <xmx:s9AiahdPhb1tKWWG_57IHXbjRJhH6bbERiKFH42OtQjaSz7OoEZYxQ>
    <xmx:s9Aiam3Zz_OY6OnrU-z3FXeMx44yzRAihPGnvnLADD9yX_TAyGAs9s8j>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 09:35:46 -0400 (EDT)
From: Boqun Feng <boqun@kernel.org>
To: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>,	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,	Zqiang <qiang.zhang@linux.dev>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org,	linux-mm@kvack.org,
	linux-media@vger.kernel.org,	dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>,	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH 0/3] rust: sync: Introduce Rcu*Box
Date: Fri,  5 Jun 2026 06:35:36 -0700
Message-ID: <20260605133541.22569-1-boqun@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2FAD5120008
X-Stat-Signature: i4y7ruxi7aywookqkasgft1sdpe45hk6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780666550-427108
X-HE-Meta: U2FsdGVkX19iMVP33p+U/ZaE9gxUjlTzxupjLarqSGyL6NncjPaUscF87MQoJYh3vO8KroXdVWKTxeUr/jJ3Dc2jA7dHHnGrd18WSEqelvIKG5ALen3SzJbU5qmgtEAY6XvivfALSn/PYuedlAE4wZ3+4U9ONyl0d2NbQUD+6nwQP5kXxWeaXTXEz2k3a2Wa6TGBqjF2pPS40CYwggHBBZ9B1ptbXP2nATGul0Mg7s3QKidCqt/IaTtQZMtKWIKhIf0rbJwwdNITsH7vQTJU6RxbiyM6NgNanvqHkJGMHXUPGQIV5Jstj6c2lT2qdfxBnDtSpTDmaZplCJGBGduBSnSSiT1WwQ2MV6XO/XEX70tfNi8pUT/ddoYFHjdiboKPSHYb4IM4bPTQ6JauguodAYuLx7i+5HniyrTLAQEzTKG6pbbcPSFnJKxxjm6+RH0a2xD1B48E7vH9QBIyJhRCAbjUAU1KZCB1uqC1mu8DxGdIXHUyyxtzLWhb4hqh4XbcpZVTQLLC6YRrpV86TN3X8UW1KUhrg6j8QmUfx6E1f3Vwongo5mO0BvzeJBEAStwmYPjx2M89r4ywOeESOD00rf+JdjgbKe9SjN5FKCPpRity7sr8ZWaHlSPCRbBPH6C4/LIbW/KjHKztg2pKamKqg/y0J2nAdMiFcPzkINUkJihvrF1H20uS/Gvd5zL90Imqylz/wZBVMgEobrDzQ/UhJK97reaoGhB70uVDP99h/mFd8Z+YRXxHa/vGKqk3/t3I4pRc2LEXxmjuHgOMZBEY98YAsFmvD/bIGC0UhLSmYqZQTYR+6FZkw17FfUxSXQQcJfA8+ZaidDJtKDxxckr5Tcs+6wwhtr1XEJB8aDxtPKL6hMKdZugAA+8bG17c/F/H0GyVKaoMSYQR8BFRbJKiEDEyTf+jVgCoLaaLKrWDqbMayt+fX7DDOKHvSd7i4glhqCrOfT1j/Hvl0jrBvGP
 gT39UkQL
 VF2/g4/Kb47o7SCL00fn2YLPSBbmdCxNgpb90MFayqeLIIANxC6zD0jc8jJqmW0bNLxPwPGE8nD8Xh0vnNr10jkWD+popH3XzNOK9HpLt8dq2USKCYNDdanJvVQ+0Fe/yDZ9K66ZUdEA4Y/TQgSa4ZXS1fhV4aSyokEVyfHwX12BkXJ3CRZ9ManMwf+Ypd9US/NpTuUejD6CW1b9YXaK0FcuWDMhnzioG5WBhKrOnAtSZyqRKGZ1MGl8GrNjP2XdcX0C/YTWCMLQZGnWOLt/9CVLv0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(this series is based on Alice's RFC [1] and discussion around Philipp's
patches [2], [3])

As an easy way to provide RCU-protected allocation, two major types are
provided:

- `RcuBox<T, A>`, inner T will be dropped and after a grace period.
  Users: binder with maple_tree and dma_fence.
- `RcuFreeBox<T, A>`, inner T will be cleaned up immmediately and freed
  after a grace period. (Name suggestion is welcome). This is an attempt
  to consolidate Alice's `PollCondVarBox` [4] into a generic
  implementation, InPlaceInit support is still missing, but I want to
  get some feedback on the trait `RcuFreeSafe`.


[1]: https://lore.kernel.org/rust-for-linux/20260116-rcu-box-v1-0-38ebfbcd53f0@google.com/
[2]: https://lore.kernel.org/rust-for-linux/20260530143541.229628-2-phasta@kernel.org/
[3]: https://lore.kernel.org/rust-for-linux/20260520131725.266014-2-phasta@kernel.org/
[4]: https://lore.kernel.org/rust-for-linux/20260523-upgrade-poll-v4-0-f5b4c747eac2@google.com/

Regards,
Boqun

Alice Ryhl (2):
  rust: rcu: Add RcuBox type
  rust: maple_tree: Add load_rcu()

Boqun Feng (1):
  rust: rcu: Introduce RcuFreeBox

 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/maple_tree.rs       |  52 ++++++
 rust/kernel/sync/rcu.rs         |  65 ++++++-
 rust/kernel/sync/rcu/rcu_box.rs | 290 ++++++++++++++++++++++++++++++++
 4 files changed, 407 insertions(+), 1 deletion(-)
 create mode 100644 rust/kernel/sync/rcu/rcu_box.rs

-- 
2.51.0


