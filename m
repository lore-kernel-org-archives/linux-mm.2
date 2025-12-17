Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E21CD6554E
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 14:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9966B0005; Wed, 17 Dec 2025 09:12:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0746B0089; Wed, 17 Dec 2025 09:12:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9376B008A; Wed, 17 Dec 2025 09:12:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2396B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:12:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7221140AD1
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:12:00 +0000 (UTC)
X-FDA: 84229152000.02.0E69AD1
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id B917FC0004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:11:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Yj0gUMdC;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765980719; a=rsa-sha256;
	cv=pass;
	b=Kuj53YGI7OPCfamB7jTj7nNdJ1p/xMphaZnm/XZnXOyE6IbgBGAgLVaV/g51cLvJXu/5i3
	9UFP8KCrCZZC/yGY65bW+OZwUvl32Excs44df+vhIKNucNkUrg2K6aL654Shfdgb7c7i5q
	tg1HzI7udVdlSDgkkX09sj3HaswGS6U=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Yj0gUMdC;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765980719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFCC+AzadfVlGXWre6gah9ux2PXfd4oGQ2inbMA+VUk=;
	b=EgHV8ejO/ZXlCkG2hL7BL7WkxNElIfLl2PMEs4yw3GkAQeCp6TBstbYukkq8GHmI7k+fO/
	GSzmpISo+/sUDutULMK3C3czQVEFPekyiOMx97aGawPdeQXwK0Umy+FDbaUIaEEjq3/Y4F
	2Eq9ROIBXa0b1bT3wiwftXHJkmZ7rpY=
ARC-Seal: i=1; a=rsa-sha256; t=1765980688; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FBptBmmkmPE6HFFbhch2bl97lKxB+Dr0T6UbgC+7IlbUUWxd/q2br5bZy4t9+HyaCqRoTJeYkjydQgWiiNdj4miFXSzl3IB+hk+YJI2aBRxhaHhONiqyrIkDEp/lqDLuRhcwASqyB4U1dSzc+ORwvrtJxFUhz4uJW1PPJtFQO1s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1765980688; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=fFCC+AzadfVlGXWre6gah9ux2PXfd4oGQ2inbMA+VUk=; 
	b=lAT6AyzS8y1fsxifcT8xKTCiWAddhl5MbkmGq2MgcAiJW7d4Y5Zkf8vhYLVJFCxbDr6DZfhDE9w76XC98aZqwhblUm/ATrHnJlc37wIL8Xs80BJNKBbuWHKRXoGh0OXZ9BFgN+xY6kZ2+Xzs6UrHPqxTaXyP4cEY0QSU/7UJgO0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1765980688;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=fFCC+AzadfVlGXWre6gah9ux2PXfd4oGQ2inbMA+VUk=;
	b=Yj0gUMdCzdatNdsJwNwXeYNUZuS4Y38rNE+DAf/YEex2XbyRDD7v0W27LZLAy1PK
	sLL5JYEBnczSYTUvWVa8v7yr3cU+QIDadSn1NBh7RFR3XhL94dqyHNdPOCybhtqNaaN
	w4xO/Ls1ifnoTUbE6kfw10BTA6EkVjtzNDFabf3E=
Received: by mx.zohomail.com with SMTPS id 1765980686277212.72937863971833;
	Wed, 17 Dec 2025 06:11:26 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] rust: maple_tree: rcu_read_lock() in destructor to
 silence lockdep
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com>
Date: Wed, 17 Dec 2025 11:11:09 -0300
Cc: Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Ballance <andrewjballance@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 maple-tree@lists.infradead.org,
 linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A20E6CF7-5ABA-46BF-8FE3-A3D1BF61F0A7@collabora.com>
References: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com>
To: Alice Ryhl <aliceryhl@google.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B917FC0004
X-Stat-Signature: j3qt7wqxpmgkt69j3idjh77mjqn1q5md
X-Rspam-User: 
X-HE-Tag: 1765980718-357185
X-HE-Meta: U2FsdGVkX1+criNMYx2iJf/fqJLLwPZNj1OezEr5NVeCp2kk5DhW8buBoMtejznSAOnQdi5uPxIbpLxz4gekdQlGni8m+kXfq00aPyq1IDQOONBKSlzgyWlKcdFKhfsTanjd1AgbuDtuvvaXU5ceanqZcU65K7iWp4P/fTFHCBofJqbS9v1F0mbuZL0UZcTR3l2B1NX5wiIRE39s3omXuppw6gcYexibd/NU+JaH6EimC0tXGhA9KCIsJmK2KIbtnMqJ95bpGAQ/swSx/Eao8dja8rYzyBAmX5otoK2ibjH90Y5NG6yOCsfxvv+55W7e+QqraT92QMbemIX76E3KDAQxA7xsDbsFZCGxySCC3izhbhpdtkz5PMGIRRJ4oKTA16tzweZXFBKfZ2NeqijdAYxpJsoy3dqmlKZACYVN2wFfBoEIaqRsuiaNfqU/174oPtyQ8HelM4xrb6+N077yNQ9p9gEQA4+clD+5un9n65fBo4M+gZ5IhBJVXFOAd/Xmmi5uiBaccT87IQvILvVk44YWYmt/OHW1j1O0ma+QImwPeLXRPOLqJBSElLXZ6KsOkIoACt915amVJ1dQzHJBAtH0GZHME6tAflxyNHly8tmUOsjrsCZksvojl/uq3wFfR8y130rZppwjBTiYrY7jS26l7lhxxy9TM7cd4QkdD8bPOLZPVegD6rTbXO7i44Q7BLUfjQeDWG2IO4+Xj0NSvP2NVWEPkOExqvWdxwIvCp6A2RR5KgkJQhuANsJewyXMcsbGHopQhaQ00Y22TSTiU2RDnzJX+I9HUrtobknAfaX6qzfjgJUlnRvuuZzIh7zsf7+SwR3D8fAvD4YuYfjqjlhBuYkQqUp0NgcpfX+pfWD/dmf+PtMhXWgb1egDuKa4pb8BNq1OAJnUr9qfuVKG/YZju0EplGlFu7JsWA1eMMeROn/U5pQnvtjSjN5t+ZUaFEPNDp8XorNmcTHMs5F
 1Dto6xxm
 CaYZF3TyLfj0ScOAHs8Aj8olpnr3AcEwRe658Ft4jLLB3m8fJ5CphljY9RpDcV0azLz57oE15Cg6V7D+h9WroaOGm/7JuanFZZGcAuyQU+tVEOFfbk8XmVix+hAxHGBGsP5ufUwIX7SwZRQoprda4ZE8DnfjenAYbm2K7pAn9guALEIpQr0BWOZVOVUu6N+VZ+IbFYk/fMNpBYT0t9bDJbdnfo8xnyrF4hM2NJ9aWhvBEmtl+042o30g8TVW7fbwliVYY9CPGj1MuW398cCLS4tjuqq/bd6Thiv9q6odTsLe0g4tQrKt6VCDgRNKe0jRb7xm39/I/8b3+v43tin5UO2KShvvgJqoVEMw8W3ulQGUsWUM2NkcZ43N7hdiCYmhk4FlNk2VWOnGVCYJn+ejXOIqVPQJKRyHB9k7aVJIziuEDi3SWzH6OADM41FNyBtfyaU7FlzcRbc8d9qZYLeQ/sNCEAzFDBbESe5ttA6oNXfuYONUgYkojYoyhCq5fmo6bsmDfPU+tofuawvnBVrdHWN9j98+o4gytdqYA1hGXVVRYBuqSfIHuJADT2n+gFcxNF3GXSzh4reHaVxRXhB50rQFl6PdYhqkyJi2TgiUam25pk81PxGi+xCkSYwq3739GSVQZ5IKScYn4Q3XYi5S8VjGUJciFsxXGnpNDL1nK8WU9IVc7rHKTv6/wYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 17 Dec 2025, at 10:10, Alice Ryhl <aliceryhl@google.com> wrote:
>=20
> When running the Rust maple tree kunit tests with lockdep, you may
> trigger a warning that looks like this:
>=20
> lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
>=20
> other info that might help us debug this:
>=20
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> no locks held by kunit_try_catch/344.
>=20
> stack backtrace:
> CPU: 3 UID: 0 PID: 344 Comm: kunit_try_catch Tainted: G                =
 N  6.19.0-rc1+ #2 NONE
> Tainted: [N]=3DTEST
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> Call Trace:
> <TASK>
> dump_stack_lvl+0x71/0x90
> lockdep_rcu_suspicious+0x150/0x190
> mas_start+0x104/0x150
> mas_find+0x179/0x240
> =
_RINvNtCs5QSdWC790r4_4core3ptr13drop_in_placeINtNtCs1cdwasc6FUb_6kernel10m=
aple_tree9MapleTreeINtNtNtBL_5alloc4kbox3BoxlNtNtB1x_9allocator7KmallocEEE=
CsgxAQYCfdR72_25doctests_kernel_generated+0xaf/0x130
> rust_doctest_kernel_maple_tree_rs_0+0x600/0x6b0
> ? lock_release+0xeb/0x2a0
> ? kunit_try_catch_run+0x210/0x210
> kunit_try_run_case+0x74/0x160
> ? kunit_try_catch_run+0x210/0x210
> kunit_generic_run_threadfn_adapter+0x12/0x30
> kthread+0x21c/0x230
> ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> ret_from_fork+0x16c/0x270
> ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> ret_from_fork_asm+0x11/0x20
> </TASK>
>=20
> This is because the destructor of maple tree calls mas_find() without
> taking rcu_read_lock() or the spinlock. Doing that is actually ok in
> this case since the destructor has exclusive access to the entire =
maple
> tree, but it triggers a lockdep warning. To fix that, take the rcu =
read
> lock.
>=20
> In the future, it's possible that memory reclaim could gain a feature
> where it reallocates entries in maple trees even if no user-code is
> touching it. If that feature is added, then this use of rcu read lock
> would become load-bearing, so I did not make it conditional on =
lockdep.
>=20
> We have to repeatedly take and release rcu because the destructor of T
> might perform operations that sleep.
>=20
> Reported-by: Andreas Hindborg <a.hindborg@kernel.org>
> Closes: =
https://rust-for-linux.zulipchat.com/#narrow/channel/x/topic/x/near/564215=
108
> Fixes: da939ef4c494 ("rust: maple_tree: add MapleTree")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Intended for the same tree as any other maple tree patch. (I believe
> that's Andrew Morton's tree.)
> ---
> rust/kernel/maple_tree.rs | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index =
e72eec56bf5772ada09239f47748cd649212d8b0..265d6396a78a17886c8b5a3ebe7ba39c=
cc354add 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -265,7 +265,16 @@ unsafe fn free_all_entries(self: Pin<&mut Self>) =
{
>         loop {
>             // This uses the raw accessor because we're destroying =
pointers without removing them
>             // from the maple tree, which is only valid because this =
is the destructor.
> -            let ptr =3D ma_state.mas_find_raw(usize::MAX);
> +            //
> +            // Take the rcu lock because mas_find_raw() requires that =
you hold either the spinlock
> +            // or the rcu read lock. This is only really required if =
memory reclaim might
> +            // reallocate entries in the tree, as we otherwise have =
exclusive access. That feature
> +            // doesn't exist yet, so for now, taking the rcu lock =
only serves the purpose of
> +            // silencing lockdep.
> +            let ptr =3D {
> +                let _rcu =3D kernel::sync::rcu::Guard::new();
> +                ma_state.mas_find_raw(usize::MAX)
> +            };
>             if ptr.is_null() {
>                 break;
>             }
>=20
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20251217-maple-drop-rcu-dfe72fb5f49e
>=20
> Best regards,
> --=20
> Alice Ryhl <aliceryhl@google.com>
>=20
>=20

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>


