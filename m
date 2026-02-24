Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E7BE9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9216E6B0088; Tue, 24 Feb 2026 06:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC1C6B0089; Tue, 24 Feb 2026 06:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD636B008A; Tue, 24 Feb 2026 06:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67F056B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:19:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07E92C1F5B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:04 +0000 (UTC)
X-FDA: 84479103408.22.16B5FB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 58E72140005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MOu8qMmm;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bq4FT148+U1qC14uOzP98fzEOEq1xubS3TDVd9YMopE=;
	b=oNUYqFmB4spZakGz1ecIya67nzoPBUCFitXw8XCfOxIy5W93Fm4CsSMY6SfqRGfMD1Fs5U
	MYnguEgS1Y3xTFs/0w0a2oh3UT3EhSHQE9O9JovOP7mgRAeS4JDRU9a+53XbeuBVfEAVDJ
	P2YZseDRSSgOq0u8eLrQBnZchW0WzWg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MOu8qMmm;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931942; a=rsa-sha256;
	cv=none;
	b=flP+Y9C0nkeippSZcTlm64POYavGE98toCqee5yeJbBcfTPePezkwISLWMIoi5WtBrFPAt
	UoTB3Gew5qLyUBlXXUv9nTzRns9MDaSTJ1C3MzC/qWuWGU1vb35SvM0h/Qr6+qnwFpIEXy
	Q3Z0TNPkx9iSkdDRjl1n46xrWRwXJvs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BCCC761332;
	Tue, 24 Feb 2026 11:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB733C116D0;
	Tue, 24 Feb 2026 11:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771931941;
	bh=TzCUGpEDUTKD6tcoKokHDlQAGVLw4XXksTwjbV99rHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MOu8qMmmrykyBB4CVhwqsAo8Gs8bS7U6AafB15auu2pLImpGtcvmUXOPslyfKs2el
	 cA6Tgr0KiCNDlclglU7X5nBYMurMj/c4b5jgIPllHvoz8I5zv55L8nL/QYuioiqNz0
	 bFHwNBCzqEwNzza99Dotcw3hy2WSMt1k4v0Nu1ObFnuzzPCJTaZJR09VKnQPVNu0Ie
	 YiaCR0DXwqb5L1MTAH33VJOtane4KNMsI/15XTFxxb0XWg50vHeumHbafF+RW87C0o
	 zS7G0Yc9SFTSe1i5chVbdD//SENR7XS47MSpwMtFs06smyoMu66VTyAuEoDPiztBuc
	 FG8EIBIcIDBog==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:18:02 +0100
Subject: [PATCH v16 07/10] rust: page: update formatting of `use`
 statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-7-c21afcb118d3@kernel.org>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
In-Reply-To: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
 Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=TzCUGpEDUTKD6tcoKokHDlQAGVLw4XXksTwjbV99rHQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj5ytywbjKxCmfhmUDrIuCRIXch3CamTuuGv
 j824oj6dJyJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I+QAKCRDhuBo+eShj
 d33LD/4tIWyZ+fNIywG0iGTvb2DorpPWbOHBNN9ywRijqdgN4kCYPMclfyWq5jb0IYw6fO5XvGS
 n3w8ZMsfLfCWPUxLJdLXezRidEemIyeulj0g1sXIMUJtJCTE5KGLt1cF2TlmAqfIGDb1Hxva9+n
 a17hvt6TxHT6vtxd6YhnJcIRECoOoIi6t163hqhNU+3Hy46/GrL+c+nTkA/ZlnfxLgaXP1+VGB7
 I5d4mn9T5xF6HdI3RAI44jmR25J4E5AypWhSJtFg83rD1WbnwAcDa+Ow11Emd7UpvLdl7IYKorJ
 VNJ5BCcmWvA7Uv5SbU6NqZ46lpaYD0303kqPl4SzHPc9ZgGpj1itJTcAZZg+7N11zMJ6N5UNtgL
 55lUMrNsD4c2ho5ywzGrZm+g8TjNVjqpCx+CcfiRj100RVyVJxpUoJsKKhElKn7CNCCvKJQk37C
 ckI1Utyd486+FYBxr0xjySMGhSl+kuUkGVSs7o4WGXtaGlBup26dnSeAkV0hwb7PIJTnVEqhNG9
 kkzffHhBC7rgSMVm/7JPpUvyMDnshDU2+oBO08eew7B5Exm7GXhrbIxkwxtnS8isIL6D8vMXvdR
 1M7UgSTMkNpZejv8PvjASBdsv1PFNoFB4h/GbJw5gpvV2ud0ebXXQu7h+wVO6KP4Jt9TmyvfoVj
 JnTkk1uh31vgExw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: ziqyx6uwptp8d7mexgoktoab47oke5ij
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 58E72140005
X-HE-Tag: 1771931942-759027
X-HE-Meta: U2FsdGVkX19DUi5HuN4RfylzthbT3h/or1lDKLnNqDN/tGSuUnXROunN/J7vggdMCqCjlE/e7ksNcEsOrRVF5DSbqqR8r/dnTlYg0KSoZ3VFFSkPZtu0b/qvOJJjy9CPkIrDd1k0Dc8Afv2J0WsVHY9kn14UdOGh2ZqXo2eB4czcVHvV48lIoC8rlpcOTD03k/ZUHbzLRxIBey4WhhRxCBCzJGxIZh/ffgG2qnnlkwd1pKBXJzqSJGlIMvOG8Rfx5cTZKeiWHEIhMhlBzz9o7Eug3u/SoJwdRZk4irqn+AQvD3JHcJGgwIjIEoSArXHduBxQzAa4lpV0Iiq3AhjDtqoD3cPX4Nk9uYxH85s53p2boC0/gzi4EWIeRgQvsSW5jjrFErZj7Ur2sqKkxvZ5Yquq0MiMMO63cTrCgubWx1n7iI+zUJddC8iLCBEMZ+RMHrKuWlThjtt8Q9eM73pff6DpvKjJ/hgBnSuyVyaj7XhmbOJhctT653r3R1FeDE6AFS5dtAk22j+dkpveb8FAG9qfIXb2qZJnMTduwI07LLoewT5ozubyUoNPmaAHa+6OMFWqoDA0JJIBgJSo1q1nRj53PaE+ZkieXZtvNYQ8nEjo3Y5M+JLuh9zhyHr2xrI7QLR5OGxfsQcjo24tc1nPyYW+3F9sRvVMj2F6exfyRVVJkk3Y7fbCGSpDUJ0NE/hWMe+503j9/awnAoNLudass+9QnGD4toUYbshVCcUnAIPQTDwRWmYLWZu+5qxgB7sv/zsw/H2/BKDlarIsj6TyOql4fTp+LTmXh59CpPvdb3bcYkzqDtb4nSXaB/UFbdce/XkUJeWvk6QZ7uJ7Hn+HV1/HdkFSftfC+kLrWarm22Sr/uRu6Ne/v8QxU0IrHGvLv9XDCX0LqKNcvnqXHfwDvTns2hs6+L752qfywik5lTVDksIjutEo7k1sJ7hVQfI1NymXif6AQHI7Mq46t9O
 ML1PRC0J
 bA/oBbw46xy+ECIOH1i+BzJaPC47oETmacpUBGA8uR82aWNI9BRODbxtamdsia3PyeDAy14HM2tMM1pTYhjBuljU83mxuFnvjLXsjzTz9haKw+R588StRtXP7CK/GUtHZNmJajyaw9ZiPMMizUcRpymWQAKIRYqQN2kumnyTwRs9dZ/Tk5g57vIwyzOW8mMsfa69DLb13YwsA3lfMuTD9b/Xq1hSr3TSqSURFj/HTzIXpUWYa41kbejLJqTsJayPYlemX8Q6PlYRAAMo04BC/0IxY8QClJqHvAWtDCWDo/IWYspyhAUlSSCaX27RJXtsxdkaie85Lg0736mTs0xvke41CJIk1wcKNy9KA6/pMEy4tzGixzxE94iscj3LCG1OEag01ey/dwGXz12xr36T53kSWTYifK/B3cTHfZrqtkVaYJJIMuN7l7y+7Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update formatting in preparation for next patch

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a8..bf3bed7e2d3fe 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -3,17 +3,23 @@
 //! Kernel page allocation and management.
 
 use crate::{
-    alloc::{AllocError, Flags},
+    alloc::{
+        AllocError,
+        Flags, //
+    },
     bindings,
     error::code::*,
     error::Result,
-    uaccess::UserSliceReader,
+    uaccess::UserSliceReader, //
 };
 use core::{
     marker::PhantomData,
     mem::ManuallyDrop,
     ops::Deref,
-    ptr::{self, NonNull},
+    ptr::{
+        self,
+        NonNull, //
+    }, //
 };
 
 /// A bitwise shift for the page size.

-- 
2.51.2



