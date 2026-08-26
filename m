Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47259C61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357396B0095; Wed, 26 Aug 2026 17:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EA46B0096; Wed, 26 Aug 2026 17:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220996B0098; Wed, 26 Aug 2026 17:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE69A6B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:43:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FC98C0249
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:43:46 +0000 (UTC)
X-FDA: 85144748052.21.32200FC
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A59B10000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:43:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=S4k+Uqxq;
	spf=pass (imf05.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787780624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=;
	b=hYMHx9v/wdYaOFJK5Hw40aGrhdiSL+DxnJwqKTEcg/JutjnMVdaMM/rDOs4q4jwXlnsCAw
	6x07e4wUa15pT1KT0DNwAMpMbuZpq4Ne3cWUj1lvDQVY47LjuBtPEqu4vcSVhj4HTvaeOD
	Bx1WX/FJE58/D0rnMZtEMbs9cKOhvn4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787780624;
	b=D8llIk+qu1JfcOVpiC6fg9CmpERz68zVkvNNB8Z2YrfOOQVQyUg9Zxr5sVGHRIWh2SU7tZ
	niY/TnDLq9LWuqUkO8+wm75sI1wGsoa8RbHeaU1teiNV7MIxnLdojXA60U3u33btwUx7RV
	DJdwKnQgpj19n7JPmeFFDfmOYpKWKMU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=S4k+Uqxq;
	spf=pass (imf05.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1787780612; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ImLF6WJxhHCEKi6DC3cgYoFwZ3htXW2z8+AwftB0gi9uyvy3jN5JjCjSv0DOnNa2G1BHgzkGlqoYuLkh+TjSVNcK3bJl5Kh2ojx3Hc54RzUoFNDEsblpqYJj1MTLGNCNghETp1NOFx/bCv4grh7eC8Ba2hhlcbziXBhizTICeCQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787780612; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=; 
	b=Wg7yr/Uc8G2+qqaZlduUCSdiXFNCiBUi+bC68K/qmPOHo8zh1EEne9PYdiAcIOUUTCY+xUmk34QeHp1XDb9oScfZBGvTgsBb8pg5XAMXRTVha9hHTTEd2EZgq4P4sNjK2OAOKwq1VdsFq+P7TsFfJSH7Iq/068Ek4FRL2rBLjDw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787780612;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=;
	b=S4k+UqxqIE38lJBWtOe3BkHacuLzdAD4MGUvl9SOtl986XKi+he8Iodm2japEnEQ
	uvL7wSFSqGhdPPvTLWxKCtRdMvzkzjFFwa8lC5fbQ7j+F6huKI+B3/YpqQewHLakbl9
	8knYZO0mPliW9VllLQHYD7J5nT3zy2Ho8gnTiCwA=
Received: by mx.zohomail.com with SMTPS id 1787780610742503.2520550080949;
	Wed, 26 Aug 2026 14:43:30 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4 02/11] rust: xarray: add debug format for `StoreError`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260604-xarray-entry-send-v4-2-965f6028790e@kernel.org>
Date: Wed, 26 Aug 2026 18:43:07 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tamir Duberstein <tamird@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>,
 Daniel Gomez <da.gomez@kernel.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Daniel Gomez <da.gomez@samsung.com>
Content-Transfer-Encoding: 7bit
Message-Id: <FC83565E-5574-43F9-AB5A-BA1C34191DEB@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-2-965f6028790e@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Stat-Signature: hj5hr8u877jr9jhfomy3h4p6suk85j1o
X-Rspamd-Queue-Id: 6A59B10000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787780624-510454
X-HE-Meta: U2FsdGVkX1/phiyXQhOmeJ7DRHCxZb2GiIgbleSyl77iOnxyGUg+V2sY+JK8pIeJ8LKr+QyZsj8umsM1UfH2wk6UgUQ+U921O6SdUU42OUg9X43wmC78g+FmeHdOJA/2Zm311F5KoxOxpwwZxF/F30qz4/szHrYnF89uNWmrDGmJzdbSNYMRy8TfjX38VJc+YJnw0r5X2InNi8OHoumqAWc8zx4KRpfm9khP/tn2Xnd+HvenypvwGMuB5YHmPV0vPy/5VSpEimi1Ld5VeXrJ4wgux1SU/QkC5R5ncu/0+qAbkc9Uh6ewcauIRTpKTpVEw7qxXeB7Fgk1lXfwugJHwXpKJ/DeBsCDOuwM8sFYz7GKTtnj/XHkm++6Q2FfAsJVROg0zcYu/GBNUZOY6Wkv+ZOZWzw8sDQx9HpBPlhjw+I/TgdPsn2LbVJUSxaUfu5JFVK8FWSxlF7oHPp5PIxF+04thV1472HjBAPl7Fvbpjd9u5c22gYkf/2biN7sl/I0jEBY2jwrLCR7YrmM05T8GpmowaQ+d17F3x89kOsDHNUmMK3qPf+LpZPAg5pb3ZIlmUI3Tvnawg2/6GQtzA0iIkBFyUodQ++y3oaJf1i2sIq64EBaTnQ03jCzf8SFmHS9xvPzhjrfZxJSvNl0UkORIis80d1hLYt9qNsZxbhBViG+ERuqxVUd+0s4RgrYOiSjHJCTo7Fe0LVgaL/DXY6oIveHoRzbf42hpe+zss38Tvj4dTcJgFs6ipf/BWKCfrVb32oWi8o3f5EVRVItk1CAAPpU6S9fmZtDTCT8xwX4hq4/asarkwBS09XD1vAUUTLXq9C3TNMKHmVOYwlYQUpriYJ42BT1OvLaIUsjcD2l08E3/MKv/kjiPUajqQ7lB1xSiFIIkX+E5ijqpOx7u+YwdMZdV6oa8BUXEnCem2ZNar8EXR62FYNwkFpi4KhaQBTTTVvslaDY/7eqYr/U89M
 yNMpIg8M
 hwj6PP0jwmGtg4q+759ufaQyoalW3E4qEiRHToU7YG1tAhwqrjNpJmrLhEqhHzP6oCDMh1ZSuYP6/GGGHVtf9OVPMV8tjycrUj5Jh+S3AXVoGqqqx17ugFPDBiHpB66Hw67gdFjtjHq6uD6Ei1ATbzHWIbgML3Io/5oKVm08qSGsV5GW6U475feM627AHW3Hx99djRdDabiyeT91NeNZelD1/NfohhVVts5hMSbj+yWInd5UtmF3dhSsykalhWQf2yVzPWfVKylpziR2TkMdfXqNehquV2xZYEsXvRfidTatw00pyL71pXTZOiLnm/sknG7E17Tz8TvEJNpwyq8dt4h8Mn+pbSsudCnuJkOJ9EpqiFIUXufcAqftaIkUWSam40ksjSLx510/4uTj3UyBqaaP1Gn72IL841FK/kLIL9pVUu1lefJcNEXTcqoq3Ge4rFhb3E2BLI/gcQbiTtaSnEwSgTCKivwF2DDrdjTH+T8+sHQYzVPPqLq6ZJSGGQa1D7fLLmfEkeLanJTVMa8wYOX8n0BbyuIqxX3cJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

