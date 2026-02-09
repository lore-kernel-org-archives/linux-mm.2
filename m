Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E645CE81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C116B0093; Mon,  9 Feb 2026 09:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5434C6B0095; Mon,  9 Feb 2026 09:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4633A6B0096; Mon,  9 Feb 2026 09:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36B196B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:38:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6A6A1C03C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:38:55 +0000 (UTC)
X-FDA: 84425175030.13.EBFBF89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 28C44C0002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:38:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgUYcmvE;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xf2CA3Q0xMY03NUgnPHCMc6U7qz2mHQ/rlWk9GQ8TvQ=;
	b=SXWKYWeQ3fLWlkzzLKWz6wkxY3DfiTOv48parmPdS/3yq6Ace8HjxmTrOjX24JxnBgRkNi
	2/4pdCmCKpi6l0SdjOJ907hzwAQRVs/5MsjrtbLYRwFkuQHn3vutv6P5CWQ0glkxOdyFUi
	AyyWzO6Ep1eNsSmsdhThUl/OVjapuhg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgUYcmvE;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647934; a=rsa-sha256;
	cv=none;
	b=CSGe274uhHpJtXgI1NNxAbLAreiEhF1+8TjGAQA8F0PwjzoywcLZpzPKj+J+3eu+eArhA6
	p05h7Nm5UJCdcDlGz5lt1QxD1c6B4f+fzkt6btee6uIM5SKEBqwGmIJurpaliDgxc2mNWX
	gXHLlFWwi2oMumtNOsIIUsRRnoMIWjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 468C66013E;
	Mon,  9 Feb 2026 14:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F823C19422;
	Mon,  9 Feb 2026 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770647933;
	bh=PrcApbk7BCNSPsQwnef2I6IdaZ2i07Y2ln8fzlwV9sQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MgUYcmvEUQ9An1F2rMEYfu+G6E7UYw7TRPeZBzGLNjCdhoccnuiCKATj05xiNBIa5
	 WW2426/lh800d7CPoGN7MiYWSKlcZbPxcVOUrE18x56MH2iZ21Pz55+lqdDDsaWTCj
	 djG0guEOEV7aSvbwvUkJvz7AM7lJv0ioRrrY86rkFuNoK2Z5nSuN5nMJrkky1Kz5Ty
	 01oT52B0DvivieFrqElBXFDR5fOB1rpoleTMhAC8zZM8oqL81S3qez8nBVEgR7wHin
	 HdNgoc3Sh59DHy47BYeSBYtXUQEsmpjB799aAYCZuF3sI5CcWKy1/3JTmUOq4fZEG9
	 XYJYElhzXAdNQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 09 Feb 2026 15:38:08 +0100
Subject: [PATCH v3 03/12] rust: xarray: add `contains_index` method
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1538; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=PrcApbk7BCNSPsQwnef2I6IdaZ2i07Y2ln8fzlwV9sQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpifFXwEdzwCsucoKq2KE54BrulAwrQmBpO4yTF
 HcVvqk8u0uJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYnxVwAKCRDhuBo+eShj
 d3PQD/oDY7iFQvP7waZGcxclTVtbgYcbDsPw2BXqzs4G4r0nEmsZ/bc3z3fctpmk5Eu4QBQBSmz
 GquJbOx7DS+XXhyisG/lSfDSZTcjM3B7djaHs6kv2X2GpCaUTA1D7we6YKiCLNQKKWSz8rPBedH
 AS0WmyqMBJGsnjNcTB6ho2HB80mJuc87vpqgnong594U46aZH98gBMZjCR3WL+eFNZlbl2hFTQZ
 Yxi8R/7glxzu6qhJhL1OVS2sNimeBM2TsYuj5g0a8QJCrRnNqOJum1BMAeieTDDW0j+3gnn1IOp
 k4kdrK3jzQ6DLIQiKbLvV/dsCJ1qX8+wny8gwKWuB4f19wSKV55RUPzmUnlH/qMQdKK0ucjZEH0
 yXg1X/DtCzjDdp4cTqS90gIquSlMVVcyZurN06hK/O8WdYHh/crxpDtb7Wtq3HHrsxnMTppHeK+
 H5iFzc0pNaUVCFYuMEDzDv3EnVGt2uGtkQE37lz8ttk2jGr2WdhUnR0ARFRLItdTm5SXRml0ayX
 cwBs5jBKuS70hr93mo9OvR/zboRwQUqq18WdAk5owQSaAEiwN0H5I49xml/jOydbTFc5S1udD5D
 QbYxPkEFxloK1KgcD15RJX98bVmLwNWlICo9n9iBiD+TPmMsnMIkqWVNHgThONOrkFG1q6/6SO/
 7naUgNlrGsokBFA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 28C44C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: i8x7mo8bz4m6y5nije946gjycdchd6w8
X-HE-Tag: 1770647934-212015
X-HE-Meta: U2FsdGVkX19HxjXaRdbZv6IPmTetquBVGl0cPAWAQ19auxZOyhbviYBqAWLDHjPn1qPMDDRbzdISMFWNqWd/4oz9uJRF54vDEdRs75vjkp2EvPHF7OFNEYRa3h9WGX96KDhGuuaU3s571sjd7cnKc9g7FMR1OT/4inPWSAxn3ELhRZxTDq01MFVldQLWcHonsfYGa1AoJn0eovZpTGbq/ubK0FL7tKBj3AEkaDm9VAhQ6lepS8IqjPb5Y3t0iFtjiz0cUMSL0/OPGB6NDlUnNXIha67IadfOa99wYf5466rIk6c8PTWOvFKLR6j3tjhanfYZjxE5dsbXO9k+N9GYl87hWN7bj4hMetuPd1HMyW2tjYfY0H5g76s2P6yCXtzFScPDEdWCd3PkvslR4tA/ixBQFrPt7Tlx0RzVKTG8Z1BIeRPhfNjlLSgQxIMnzJtruCnWIROd1Fp/qecXIJGXDksM2ETLQ/v9DlIDNLdmbLIelKJkHYov3Yflp5+JbhE94FBYWIoM6wEjhXO7hvK48D/glQWG99BS85iB+n+g9MbrnaTei+7AogxHARJTIVxElBHu6bZy4/FlDJ5kREdEbOWj2aqZcAbE9+uXgV9N8m0d6HwKUI2SqQH7wOcyVmT4RJM95FkG3S2Ta/jKmHW1Mi4C8epzQWZgp+0F6jKrjrsP7fpL9BvIuG12FXFL1l7ouVG/66bqRLaLYbyKT3Bn8bw8615AVlQMH72tT3Av7l/7U2QpxIFVi3ltUsaSj4wWAtwkgbZyQxUNkURCzIRHidB7Ttv7Ff0lQS39tKLRYaEwlGLk986P7stOyQwfPgcLF6jeq2vf38l7TEmgdZT29Nq13ky7wtFQQl+8HI8qdE9Oon/yN0L0ozUvTwkDY0WMWZNL1vFHX6e/UUvK2RK+Zey2b9JMGbYlXyRFpfEtbMJ/rIylU+DQiCoxQ/sTO6oetUkuR+s7jXNPYziamCG
 iiXmezTa
 asTmSV04Er9DmkIIGUdiZTlI7l6/DKvrgVb+dw6mhBDYB7KEMy4CHEh54YuMAhhJcZg4DXI7kWYJ1p6le+7Siln13tKs8SdX7C3eQuMT8FJrPWhbiM2q/KE91Gk7hiQJkac01pHy1sSpVZ/HrQJMFqXK9P+7WGQzPAmq6oY26jae1oAhHi72PLeIxwf3ph23GitFuEQAEoFMPziQXKfyhLY1oPvb54CDBKVY04wABFT16RIVl9MxX2ibhHpKYhgxikIcDs4yPG5weyTf3WrXFf2vHrtzjIz2jKL9XUv8yjtp0zTQ+QjCqHWZ47wZ45QnTmMLRs+7hvF8wTz+smoNA2GtIJRnUvPqjt7mPlellZJ179CA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a convenience method `contains_index` to check whether an element
exists at a given index in the XArray. This method provides a more
ergonomic API compared to calling `get` and checking for `Some`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index d9762c6bef19c..ede48b5e1dba3 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -218,6 +218,27 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
         Some(f(ptr))
     }
 
+    /// Checks if the XArray contains an element at the specified index.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// # use kernel::{alloc::{flags::GFP_KERNEL, kbox::KBox}, xarray::{AllocKind, XArray}};
+    /// let xa = KBox::pin_init(XArray::new(AllocKind::Alloc), GFP_KERNEL)?;
+    ///
+    /// let mut guard = xa.lock();
+    /// assert_eq!(guard.contains_index(42), false);
+    ///
+    /// guard.store(42, KBox::new(0u32, GFP_KERNEL)?, GFP_KERNEL)?;
+    ///
+    /// assert_eq!(guard.contains_index(42), true);
+    ///
+    /// # Ok::<(), kernel::error::Error>(())
+    /// ```
+    pub fn contains_index(&self, index: usize) -> bool {
+        self.get(index).is_some()
+    }
+
     /// Provides a reference to the element at the given index.
     pub fn get(&self, index: usize) -> Option<T::Borrowed<'_>> {
         self.load(index, |ptr| {

-- 
2.51.2



