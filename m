Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3FACD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162F56B009D; Fri,  5 Jun 2026 09:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC716B009E; Fri,  5 Jun 2026 09:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D506B009F; Fri,  5 Jun 2026 09:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1E3D6B009D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:38:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8508140010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:38:11 +0000 (UTC)
X-FDA: 84845962782.05.598CC6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73B6080013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:38:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OG9k2hxv;
	spf=pass (imf02.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780666689;
	b=JM0/Q2Gpzrj49efQ0Lrbmm9CyGBDpaPKTYARPgVxJ3RIFG+Q+Sdvte4xmcsiCSnfGK9aIv
	EZrqpezFit7cBKfYohEzaF4zk0TTTkagx4F9/fA3HwPKXiGXBLgYH4ISw5hD9NLL23WH7H
	IeZcE1Rm4jCQuFsuTuWBRvESaxmPBr0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OG9k2hxv;
	spf=pass (imf02.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780666689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUElHjjSr/wCG09eJuAWs4nSH4fgcOTWg+17svsiIlI=;
	b=vXclSUxeF/Wa33C3zr903P5e+SqAh7iLgIthk+VGX8kuB3shP8g8W8icb2lSZv3M4ujc3q
	xckUbjI+uQpvciPPoqBJDunKTxRZmVgJEgxh1yycMY8x/xCLmu+V0XUmXAFMiNxV6Hk8jz
	LWDrJXfD1hEmJtEbZeFVZB/R/kJXlE4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1BE0601E3;
	Fri,  5 Jun 2026 13:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A46A1F00893;
	Fri,  5 Jun 2026 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780666688;
	bh=aUElHjjSr/wCG09eJuAWs4nSH4fgcOTWg+17svsiIlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OG9k2hxvR7H2l3Di+gaBO9Fb8HG8b8OClHLonP12Pco4CU2InrbxU6oKfTgPHc3Yf
	 R0RxTjGZvVVsyHPCEZAUb2ZooIcRogCXWwZ+4IizG/D45HB4YLFrgPwCfq3ifdxfF1
	 GEZX/hDzzIjra+QC0+mHU/nF0vhDm4MrhG+X2yRmmeoeF3EZMhXqCjKdfX14WMiq0Q
	 IHNE5HuVOuLyeyGDjFHTdGXQQEd51QZa7IWb/aYV9lMjkS4LissMYQItBUl6nuRfjV
	 2u4EIY9Gtwe1NwqtM4TBoWF4rc8OJYtgy+ib6ebNdAqqR75H0UVhSFvf60EBJKQz3e
	 qZQPS9CqZXJqg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id E1F9DF40069;
	Fri,  5 Jun 2026 09:38:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 05 Jun 2026 09:38:06 -0400
X-ME-Sender: <xms:PtEiatK6eLii7KziBaBTT8wjRaVWmcjLxXTg6xUvAOnv2sFTLGq5eA>
    <xme:PtEialm4ZzymOsemKfvmeIS0Gr-Ca3sAfyuazH0pkyee80LMDt3rzBkSQnzegHoqN
    XlQqG-Ac7dCnEukcYvf-nwTQUobIsaEP_LSFNJzDb-28Vblqycsow>
X-ME-Received: <xmr:PtEias--sxLWQymblUXu_M6gKU8ZmrKVjAysmr96GKYhelqxwByh3SmIPto>
X-ME-Proxy-Cause: dmFkZTGM2UkizV+reMWXsdwOJhYIOL/j/0ZD8k5LsRt//sPW6kjaf/1MAAJ0mS4qvAWJgr
    15+ZE9Ned2LtlVaSIU/hTIK31lh/ZiF7B+6Dl48DgBzoVccKuJMd4aizR50L5yXembF5zd
    WRdevGEw5pSn1Aeg5KzCaeplPe5IioSwoezYandUOrmoD1L54WQwDc3vi5fY5g9Iz4hip2
    IA22r8289UO0Sed2c+lFj+GJ/uNQW+50/kDj0dlPgjjbwaStax/Dtg4Ihfe4AAFyy9lyV3
    ytF+09oOPt2XLy/4hGi7Rjmwe+luN8JXrhtMX41ZDdPdr5SUzyVc0wPipMuMMsFN/qP7Y4
    vlvWIn4oKFFs5cDfKtpLIOpgf0tvY+jUlf93fzbNnDt/68bk08iWkzm7a9LZAXFi0jcjja
    anStgXfOiYQc7NykiIvESKjdbaAXID9EkTiRRiWRazyjO7ppNO+ohdQu+2KGRK1Ci0Yy72
    u53VtHJSqNlNswggi6/fGyg+BW1RItpPEyNZR3/EAnYagL4E3XpEuPq5mK9lPEUG7lm9rU
    W1v3pmB/5ZQjAjGPD2kDPlrHwv57tADfi7fYLHCdP5sqxfxbTrepoQxetAxKlCQvqLgiy+
    rD6Re6dvHNNw2pbagIyYAr/zUHrG7mA5sTaFd93oywdG8moYw+mbia+m4AXA
X-ME-Proxy: <xmx:PtEiak5UH5o2U2bQZ6whoDhkH6AfADeDIOpZuV26jyf4VZLbvvJGYQ>
    <xmx:PtEiakpe4HQpkkrrqd7v3fu_o0beu-hZzcO7RbSBSXe2jVZrdX3xRQ>
    <xmx:PtEiaoCY9saDv-squihWfpTXi638dd_gwAadllMsnpKtunPHWfqOhA>
    <xmx:PtEialPj464sUHdR_5m-FdX7cd0CBs_DHCoUCnQ2LeoxYcQ0AvbLMw>
    <xmx:PtEiavnekmERjw_NDs5-r3W_q4_Gbg9GasfZUCgXgpghQvfc6CsXkau3>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 09:38:05 -0400 (EDT)
Date: Fri, 5 Jun 2026 06:38:04 -0700
From: Boqun Feng <boqun@kernel.org>
To: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
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
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 1/3] rust: rcu: add RcuBox type
Message-ID: <aiLRPNuS9hDMVUJc@tardis-2.local>
References: <20260605133541.22569-1-boqun@kernel.org>
 <20260605133541.22569-2-boqun@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605133541.22569-2-boqun@kernel.org>
X-Rspamd-Queue-Id: 73B6080013
X-Stat-Signature: 9qun8oi9of8pqesgzxz7beg375tgicuq
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780666689-986861
X-HE-Meta: U2FsdGVkX19ShoPrdgu1m/qnZ3tOPKLrAGBYyQ8mEKl0qnZgWCwa5MgHhvNq7+W8rDqZaU3O/YhsIHnJt7nA1ycyXmXsSz6D7thf5+mMviWtHD6sowh14SasZ3T5a+M+JAgwdl2YXmnEO9lv7pau9bsRaSPi1iCeH7rkHagApv4MZuv9CJxjZcq9GGl2Xp19a5jy6udj7K3ynrZ3AP03p0Z0lLP5S6imBlBcapY3FdecJgFk82nLoh0nJ8+/HSgNyt9fHiAxpoMpCMW9wGhScSkwhkwg3fFaqX21C2oXYFzDlfiBxBAmlIN6wWhbQNSbN/dxf6lei7VUk27e46uTKuotNh+6k4SlKwwUsqayn6EBTW6ui5HlypB4dJvkFCMxqOjizsWl0S3FLk7T7Co7q6ivsoAU78EzuecjLxYBn210Lkhj2JPlihOi65dmtv3Hg07YhUepxrn0oQcVJ5KCfOuKpnWanBtHa1UQPEV6X4aD85yAqWevcOf2ZXx90JtZ++Z5hBaCdVDjRkow4xVtjyaeXI9/iCejpNsm6u3hsYpGdPKnsDfpYLciNVVnxjC+0nV2iBLasdhbpJNdZoGay/99JRdjZKN/LahK08Kbyv78su+FbSR63UO2wGwqD/NzyHRemjsIiIK3Z41n7ffccnoE3Su89NAutsthWvw8ftIB10GcN7vn3SFfjX7V3lWeEiM4JdzKGz4nhB25TkqqJOZFuUZDs5Sp0MyLdu/PqH24aYJqNdS7ENJdq0sp9UhBlzl118cJmrecVfR1X6QUmkWWtizmY5o5Ek+CMeX5ByHV3338tuV7kCTysSMKSC7tZyA6oArx/okr6I68QZITMDQ7hIuoi8kDeULoOKr+SCsJEza/GtrpE/o5Ex565xIOH979Pjtd6zMUhlF08bWS2Ped87NrHJM9VXmUrDL3MYsfjxGn9we62n0CmAjhQt8wy/QZYovEffpwzBWiPYO
 QCqFKdUX
 YTtUGJPXiLjT6r/Z7PpNNU2+Ge8oqyQ3NsS14KXjThL9GUvzHvM4lNAUbfYIbbmonkqERPZenOzk0QQ56wfU3XZ0UsBpIPt6z9IrLe8ye+K6NpoyhuHTZ/7K8B0o4AqSUUVz8re95H/1ZiU6zpx0NgNiJAw4E1YNwj7jDBtbj7XHVzcf2d3a1Mj+vkVUSTrKRnKz/zt+x12LnJjByQI9c5MXl6lwsi7ySDtTr+XoqaOEVhjDpCvEeBpoS9kBp8wDKiCrwiz3nsILRMmSg/VSQq/yq7R8Ebt7GtMbH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 06:35:37AM -0700, Boqun Feng wrote:
> From: Alice Ryhl <aliceryhl@google.com>
> 
> This adds an RcuBox container, which is like Box except that the value
> is freed after waiting for one grace period (via {kvfree_,}call_rcu()).
> 
> To allow containers to rely on the RCU properties of RcuBox, an
> extension of ForeignOwnable is added.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> [boqun: Make RcuBox generic over Allocator and add tests]
> [boqun: Add type alias for Rcu*Box]
> Co-developed-by: Boqun Feng <boqun@kernel.org>
> Signed-off-by: Boqun Feng <boqun@kernel.org>
> ---

Please ignore this duplication...

Regards,
Boqun

