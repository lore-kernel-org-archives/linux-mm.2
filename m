Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6062DC4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3546B008C; Sat, 18 Jul 2026 01:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D5C6B00A6; Sat, 18 Jul 2026 01:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155626B0140; Sat, 18 Jul 2026 01:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C00566B008C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:33:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 299B21C03ED
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:33:00 +0000 (UTC)
X-FDA: 85000778520.24.91EBA4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C41140008
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:32:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOQtiaQ6;
	spf=pass (imf01.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784352778;
	b=KrlJC8qIHVMKN4w8gOGYqC6SOmVKgWup077bkJhgnQ9rTjGKyGls7fuFjNaXFZBqveb4fk
	dJdwNpwAf1c9YkgszCICvCHBzpuTp8KKj9CoJdOer5x2iaZzMRmr2p+h9CJkEsszaUxfZG
	sZzSSreaRux+o008BgscB2cOTUoHias=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOQtiaQ6;
	spf=pass (imf01.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784352778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kwtjjGmmiAFcJH+349xh1RmY0+cdYF3UnpCgzEY++n8=;
	b=sqqggkgqcNUX2UbbdMH2Ut2NsMpRfudlbmUAwfjFmIgrWf78PwxbSIK1TKd92+9fSGyD8+
	gQkPWMCm7NEbpY6gGmAG62FJVh0NnAD8jj/OHqDWVbkk9enGv0GeJCS+BbElRSvRaFfX0I
	tHXbDcerlIa28id4gOmXC/hdnk45aAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3C55600BC;
	Sat, 18 Jul 2026 05:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9A11F000E9;
	Sat, 18 Jul 2026 05:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784352777;
	bh=kwtjjGmmiAFcJH+349xh1RmY0+cdYF3UnpCgzEY++n8=;
	h=From:To:Cc:Subject:Date;
	b=EOQtiaQ6nmW/x59ilsYVxtoSgBJj5WvdLTR4F05KRrRUGLktimBgD1StbpObcFt9j
	 XXufM0cGb+rn5QRPxtgxqQY15aRP/45qMqzQyw6QkQjqa5rca+CcZzjVyMeKlCRiId
	 x5bRucQYnwbsSs/4Hg+YaXG2pgUtZ6Lh7dx22ychuQgQYZSOx+1OuWyS1OGo5B4Bu2
	 lFvNRHXO6z8qWFhah47bqUJLHcZg6xCqmzmZqYwfQ/Si9Vk3yLsnUFLpMLBuXpgZpF
	 doZRxoWSeEx3rpAojEeimuJheITG7jxc1bIQUhXoYexbO78A7aWODd8YWKWasi28cQ
	 nbBt+xSIEQdwQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3E035F40067;
	Sat, 18 Jul 2026 01:32:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sat, 18 Jul 2026 01:32:55 -0400
X-ME-Sender: <xms:BxBbauwHm1FcfFvmUjGng9huZPoSRclRePWS7b0VkA--cU2vHYh1YQ>
    <xme:BxBbakFCAEwq9URGxa9JfhOhiNojXbKwwaJnWSuQjPDp00hUmDsuvlLK-vxfdwnEx
    mxyIUtNaUa3_GZJKrz9srYzgVuUcrdzI3Ss0a04xMGZa13t7lWuvjo>
X-ME-Received: <xmr:BxBbaryYUd35u1l0--7nv1GBJZf6twciiFCv0x18wAdN42Kyi_Co-2FMGerL7BbIlwSgvKBaduMWlD47rFdT4yVFmfGL7wQr>
X-ME-Proxy-Cause: dmFkZTES8M4nCmmYKnGMqobh3TqhunEGFElLNM+viRad93RdmeJRGfaj0RUMOtFBg6bXs7
    ypRH2PFkw0ks3z7mx1ng3QrV7lhgf1fSoT2136oH2jbEe9eoM7ag0CsJVTgNRR31HEuUg7
    YaUSD28NyGPwedMfKZngj2o/+7VJZGW1f/u4fz7QhpD8PDjuuOxyPNmNaRuF+xecSzJNfh
    u9MwMO+JdQEtSmeM/ZgcfqHqOtf5Ik3jzWJgBntXvL1J2CS8mFHvJZhx+DzRmfWOr1Mv9d
    80lUu3lcp/F+8I7Vz6nFvx4UxoWaXhdO8e3rKesyTqFCQYvNgIDmw3KjYp8Kux0JHTJcjO
    2GnoBLq6JKO5fF5OKZWIUK2LOvJ1RSiQMRWG3PqZfJkboQ9IoWIS+2e3nPa9gLGjyzzrGO
    EctPrVXKnEzF2+RZf4WR7mkhGQNIUXxdvuwnETBLLwA6S9GK6qZWJGUIa3WILNk3JlS5zp
    GfF5RHdxNfuM3+2TIKaNimuf+8WUiwPv3ARjlQZm2ZkB6c/jTDDec7tgJ6EYeoNvXJt5ss
    Y0H0M4WKwFjhA0HRovQGmgCy4ykb6gLtsVkfaFoA5W2RvVDkaYwKbEhpMfVuI3S8zEkdqE
    ajC9oE7GWZt30rlTAIOg01uzdJ4dngOidGReT9RsKS/FhiJUbQXFFOw/seww
X-ME-Proxy: <xmx:BxBbag57_HwhpOYMVPGkzpr6q6_JGmFSzKcxr2VuqzGR4aOHtHe2rg>
    <xmx:BxBbaq6-bfpiViAkVZVMbLud7Pb12b70zxBfx-5uUn5WlKXHT9q7fQ>
    <xmx:BxBbapKXT52eXSePdRzpL6iW-nlhuCSaRF3ok0KtMGYtQdbuywxUZA>
    <xmx:BxBbasEE9fe6KiG8C753GKmWtFz8EZAcPaDz08KImbAiXjQn-LHf8g>
    <xmx:BxBbam2ISzee3hCoD0_v6Px5DeOx0mMncavCQ3yd-e1qXTntz5AqTcOU>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Jul 2026 01:32:53 -0400 (EDT)
From: Boqun Feng <boqun@kernel.org>
To: rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>,	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Lyude Paul <lyude@redhat.com>,	"Paul E. McKenney" <paulmck@kernel.org>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Matthew Maurer <mmaurer@google.com>,	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [RFC PATCH v2 0/4] rust: sync: Introduce Rcu*Box
Date: Fri, 17 Jul 2026 22:32:43 -0700
Message-ID: <20260718053247.25154-1-boqun@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C41140008
X-Stat-Signature: f4n6i3ga1chaqe6bg43nirurse8oxroz
X-HE-Tag: 1784352778-462844
X-HE-Meta: U2FsdGVkX1/wlMSRAwyuO+4JaDT/32fC57Hgz+DqBZdeWhXfqhNF+5pBFd+XbePPq3f4mcFLoYnBsPW6yH/SVY01URIJLH17Y0WRNrrB2AYzzd40X0pv9uAbqxQeuNdv5/Zo7EtW8rRfXRrLItMUYOxbNrPenuGBROTx3dVAogFx10RU0+yqn3Y/vzRlU8JP03l9UPqkkeYYVMBxuU9o1esoB7jWujxzsLV9R8OqCRaQR6AKNzfAi119a3lrRXNJHdiL9yGn93/H+w3FRx8+/hbQz9CRguPhOuZHhDE6C2D4B07uUvar9lzFe6upaGzbw6xA/TMVwRG6z2tRuGIkYaV2Ua3/eqcAoEJk4dtrNj2f3m4CzY6Su3pAW7dbKG1SYiuh/sN4D/YXuG7/UDjRLPeIeGjV2wSAnJ7rtijPW+9Tmyngf88J/atXMumH5ZXCVRdsFb25AYcf8QJMDqNO/I/8gLEU3vMCkUPDbXjwcuEBGeiJjfhX7wuyUYpyq+exn16ZmhFbIDFILgYnMA/wJbOXh8zVTP5M4ngze3VAPsY1yxBFEFvcjOj4sJ8wwvZHm34mLMn5ErORb4ACYKVE6NMbLTaX1HBJCmx+YWiQk+n6BiOG2Av4UwK6GFNLA98+/u6AvWzIZoSfQ1qFDb7B8eVNN4tpO1vJFA2GgTPuVfQjoXeyHiKmH6Pg99mbKUQp1l6Fm24vB+BXKI5qkLxgKl3lH4B4HG2lMtIKS+Jz/WsQDAONU0QIh+cnczBPZW0fBCfUlbEqRWtQecjmJ36D6INN/BgeK0JvBpTN8jNbndlrwvzEL3CO26pK5v2VrMH2b25MbfWAgOs46s3YDFv6AYm+ppEjIJT0YyMtYAzzGit88hmgeofYpbS0yR7nYrJza7ohTKg1VDjAJ1C4XdFuwGVPKF38nSx/WQFgRW2oXfo3OiutRb3z9mIDTg62M9tPG83KaBmz6Xtii6/rpFw
 YqVAuJWF
 1K4RRuEan+0JrK2YanV6f0kAsh3AJrtlh7pB8ppA1N1GILCvMnDheLgZXEp1+iHMsJ2Y9ixPpDWA+c2uZW9XmRAxKUjey6MXCsyPpDWGd1/HjABilpJU2PQYEA0RuIXFQpgc6c5le/YQKKWJIn7cUcTG4khQv0wX5p0sOiqACqZlZU1knrSS2mTLwvrKhBF+K0W33EZDdR4lidRxajGLhFndBQjOIarwSLsKXD91agbpt3Hsb46KIgzicRaZ14M+OPD7U0721go/X2uARk97nX5g4QVPKrHSuDhOwIO9iefWXxe4qPM2TXpJk65M2qAVimDWbDuxF8DqTRAfmr/hU+lnd8bYtqALSSxvwNbzym4ykTnBckOwBlEG42ylzj4i5zwD5V0JMvETpuXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v1: https://lore.kernel.org/rust-for-linux/20260605133541.22569-1-boqun@kernel.org/

Changes since v1:

* Rebased on 7.2-rc1
* As Alice pointed out [5], RcuFreeBox::with_rcu() should return a type
  that disallows extending the RCU read-side critical section to
  outlive the guard. As for now, no user needs with_rcu(), hence remove
  it.

* Includes a not-for-merge example based on Alice's patch.

v1's cover letter
-----------------

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
[5]: https://lore.kernel.org/rust-for-linux/aiLXWHg22P6OTb7O@google.com/

-- 
2.50.1 (Apple Git-155)


