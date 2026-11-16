Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560BD606A336
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6YGkIo6
Received: by kanga.kvack.org (Postfix)
	id 7F4B96B05B1; Mon, 16 Nov 2026 09:22:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5046B05B2; Mon, 16 Nov 2026 09:22:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693106B05B6; Mon, 16 Nov 2026 09:22:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 447F96B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:22:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7F001208BE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:22:07 +0000 (UTC)
X-FDA: 85441196694.23.B745359
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1AED1140002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:22:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6YGkIo6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794838926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9998Op+ciK4KzNkfg/cHkmiaE6KVNwv+CiIQ7yuk35I=;
	b=D13Kiilozg26rvvpfUvgOoR+Ag/i9HuZ+FHJazb+B7OUC78msruZmoIvX4GVWbBRjb2urs
	1MxExXPLw88yuUjntXIK7cHte9mmuxRCxVDr4N9m1GAdqUnnktPJopLwC/ji2ghLumj9fL
	oOUMLm9PC4VqH32mG5OLWiMYXYIfea8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6YGkIo6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794838926;
	b=LiyMuz7kBViYhZAGj5LxZbjYNQdVuvlcgNZVAPsgjQ4JSPQkqxSl988YkKDK4lZQtRE1gZ
	nPEtGOT/EXF2xMrlZFdrV5VsdxHAmiIATejhd1SO6j+81WcGYZIgGCV8KF1ss/c1je+sKj
	15CRIRamEPKJgJNVexy6v8M+sGIc9ME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B749243EC0;
	Mon, 16 Nov 2026 14:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35181F000C6;
	Mon, 16 Nov 2026 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794838924;
	bh=9998Op+ciK4KzNkfg/cHkmiaE6KVNwv+CiIQ7yuk35I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U6YGkIo6jSIx0cKZbIhjwuEgIIlJTCZggyc7Z8QV1XUlyRujA+fOfTj05QIdFvjmc
	 1GPlHh0WYwXiceAt5e+EOb4TWlJ+ekRtWUEIYD37Ry4cG1eM3BBsusAQmgNbH/nwwg
	 J/pDQnGW6254ZHslJYec2SF27t3v0Zu3mhyEkgA/Fj+QnlisuY9EZqeFnEhdKqqEUD
	 0HdO6MGaCIEyx7ukZYHcJ7spKtuVXByl9n84BG0R98l2e8HuWNmtkQ+Vl4IgfLdUWQ
	 YGpwfzqTqS6+oPT6wB/Kg6uws6N87/tmxHVLz/vMiKNzHHdYnFIi9Pgs3kQ6f2gjXt
	 Ez1w8IoBWY5ng==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Nov 2026 15:20:58 +0100
Subject: [PATCH v22 1/5] rust: alloc: add `KBox::into_non_null`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-unique-ref-v22-1-12029383206d@kernel.org>
References: <20261116-unique-ref-v22-0-12029383206d@kernel.org>
In-Reply-To: <20261116-unique-ref-v22-0-12029383206d@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Brauner <brauner@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, 
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Johan Hovold <johan@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Dave Jiang <dave.jiang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Saeed Mahameed <saeedm@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, 
 Jonathan Cameron <jic23@kernel.org>, 
 Markus Probst <markus.probst@posteo.de>, Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1214; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=nnq/EApvqpnDipb7ZMMGHyUc30IDlzBw/XCY2d2nR2I=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq+xFRqMYICGBG+ejnnQrHCo2Qiew0xJ4tKwFW5
 FAStlInHLGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCavsRUQAKCRD6UCkIqsW9
 0MiMD/9Q8HebKQyWtVT3j+58+5Dz3Y1m3kT35wm3KPbPB7t0UAJ7ogziU0L97LGVruRRB34TcTu
 1CXyHSibnht9sqUnd3frpfwAILOszsx3O5g92cMyi6dAOnpfwgYfsJrgS76YDxIMSs6hzhbW0b0
 ZdTb2ogrtqwYoTSFPq9Yq8Y6Aae/klTsQZ+5zhYq9x/i6eeksYBRrAAthMHU38+eNUbptna92Fg
 EzSDCS1x4Lh0+8XysAAabbtvDCcs0rppOnCBCF99huGij8Uru81TKzD5FSbmYo2OinEXo6ctGxq
 +E7p7ZXvkQgf86OcwY6ZIgpDBHrtcE9x0rFxcIptzBzj0JJOEzWA8iRUoQrzBgdNXbE2PeEe9Vi
 ZpClcdgUNxB23pKbt8fj1tC/ohlfz563sEfVMmOBFp9z+4GLRtI1e3iQur4L+mDabf6kJPtfUHb
 EHJvSgpc+mdZAv0AXN0TE6romZIfZzrcJNDWVgOrEBEXYh20BpHI1Vyr6KM+eDa/u7fWNkhfKAF
 2X+DzyfE/T9n55HpdJUdtE7HxKbJ6oMkeTRrviQjc6Qfd02CAM+g/mAybG5yMMJrCGm4hCC1AGr
 gWM3HjZl5l241jl1zkJkDbw2N1pUvs2AavWjD34YQP7A+Bw2GSakJGIeQgVdVGd4rK9bU3AeBbU
 hfprB7+xbLZOC0A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 1AED1140002
X-Rspam-User: 
X-Stat-Signature: x3uf4hxpzgfj5owc4imtnghd7pwz66d4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794838925-570387
X-HE-Meta: U2FsdGVkX19EJmAmxHGwNZhcO4jFy3gxUk7yWVb0LocgWNj5LDxoFFKad5a3qvNKzcJWTvN7G7QRAhJgK6DW8BzxzBR+OcnHfiAJHVX8lga024JhMucW2CKv6XfL6ot90O+QTv9E/JsPW9oyi6Uqi8NRrc2B1JK0kPgQ+6m54938KTkHGdKTz4PQcO55B5bAVaLLwFnrb1p3C6mr5tGVRtVuv98vwgacaJSs2ieWD7exjtUpzJGr3/R25dcx1NbJDN5HvgG71ICbIU/BKt7pAm2gF/ihKPKicmE0mlS/Uy+CsHZ1HgGv/eWYJzKJ32mXtnsbjMvJf+25uPlodQu119CeaH3CuN5mploDcx3aPmw63oJkLeCQmL81BkNFV2sqU6rYMqA16IxjzaVyO2vjTA0DEHjzc5/nsxGpDISxWxCLS8yjOtwHfknLQSjbSGxV4KllI259LNOLdxGGoTJ8684gC35Fq2twrJiFChs134oYZRPlua7afDdwESTBVsjIgra0wG06xpxqputYlMK5A8q2is9EMrFVrrlfFX6CdhkM4sm5IcMXxZiOK2bMak3vVOIXhoXFe6yziEk13/CYtYl0vJ3C2jdN3FzUjeChfBST0uQgKq285YJTVTqXAlOtdNA8TidEg1B6rXaXhpCYTXIfG5bAlAD7gQX+i8QKjf4REThqMYCsmx5kQ6P3KiA3op1tAp8lFD/OMHvy7uUQCx9qCNwRXUSErtsZIVfcJlf7i+51bScoK3PJzA6tLVu1dZ6NlPEd8/xMON75y81ee/RJQ4WGwIQz0Q8YMCJXCzsVCsy4VPMaSJLxzxMG3zYt1kY7JddOYKKRPMwKdhUzrlNanVl/jCwUC8bNZ0dSoORvn2+jw/K6rAJMN6OSQSbPnNWtwtK/1d2y/nGFTzUpT5Dna9KMIwWmDY8lyVsl0lYdGEUdAL0FnVkQrcs2CZ8p7SAp/HMOCc1qAhg+7fg
 IOwz0c6o
 LiR+SS/cNJ8ViuJys0ZeY7bO2qgrBrj2uIUA/GVU/FsmPlf3xLYgOYMGCF/fKW9dkbDkO4UcO5mf/adM5DA8mhPlwp3Fcacl3rUfpklr0I8xAg6ILoqnD/igGf+SXw31/soH1pf/vGceGVkZwCDUYCX/DV4HuDb/eSetU7shDbQUI/q+CsRZg2GKyKuFvAK4OeLHcn98PfGYf0z088m27ubPlU4NejTqI+hRY30JxEFPTBrAJKWy9FcqdNdDMZNt5Z7mcnusyoFN/chyn24l1FpgNAE7oBEaU9LvrMHwx9oC71yVkMZxq41Rjbv5ewBxX01/E9H9c3zi8vkHzpsI5WgnMH9F788BoWoy65OXfIXTABYL1ZBMYpd7OhLcxwkgaKGbOyHmmaZIcBQTicYTgyj1a0pNKKtffPyuO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
is a convenience wrapper around `Self::into_raw` for callers that need
a `NonNull` pointer rather than a raw pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Danilo Krummrich <dakr@kernel.org>
---
 rust/kernel/alloc/kbox.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index 2c929eb1c3d6..7e8ce3b36673 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -211,6 +211,15 @@ pub fn leak<'a>(b: Self) -> &'a mut T {
         // which points to an initialized instance of `T`.
         unsafe { &mut *Box::into_raw(b) }
     }
+
+    /// Consumes the `Box<T, A>` and returns a `NonNull<T>`.
+    ///
+    /// Like [`Self::into_raw`], but returns a `NonNull`.
+    #[inline]
+    pub fn into_non_null(b: Self) -> NonNull<T> {
+        // SAFETY: `Box::into_raw` returns a valid pointer.
+        unsafe { NonNull::new_unchecked(Self::into_raw(b)) }
+    }
 }
 
 impl<T, A> Box<MaybeUninit<T>, A>

-- 
2.54.0



