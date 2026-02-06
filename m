Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B28EE6B60
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076446B00A6; Fri,  6 Feb 2026 16:12:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040F06B00A8; Fri,  6 Feb 2026 16:12:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBA6A6B00A9; Fri,  6 Feb 2026 16:12:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD49E6B00A6
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:12:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8BB4140357
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:19 +0000 (UTC)
X-FDA: 84415279998.04.7AF42CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F31D8C0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:12:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyhNNPYW;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770412338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ideqKXRl+KC8uyTipqZC2c0hD7mkSSa147PGCFe88zQ=;
	b=uC3QftbijC/NZoZpHZycMGnE4jNgPTL647MSNe1mFMehfZ7fjLKKM78wyf5zKmVoIv7Y8K
	EkqKcNcQm4meiuOnfLIY00EAQ9/3BAyWrxGiNlHTNr5GAHhEoJKEn51/TknyeBYdcZkkUb
	ctjELmBqdvZKojU2ihkng8hsL+vD65A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyhNNPYW;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770412338; a=rsa-sha256;
	cv=none;
	b=JopfoB7mWuVvU07VBGwsD2YoDSOVZ19MlLISvdt5HxeN7Hic8YByRYpGLILh12H1uQbh7d
	xZfDXz+Wc0upTMYL5Dyo1I3vBIBLaB6iiaJNh6/bCx23pVUf9I+dlb9KDSsUD+bGKFItNU
	2wlSSiiy+AVZPLhCyjyuPrvCg9yThis=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81B79601D2;
	Fri,  6 Feb 2026 21:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9C7C19424;
	Fri,  6 Feb 2026 21:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770412337;
	bh=QeBXOf7iICj0Ad5qHcIJv0VhQMqjDmVdKEV04oiCJGE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nyhNNPYWM1GLHkWakHwZEPnK0d6uMc9aIrhlMgVy6Ek1MlCQInIw9nQ2+5tDDGXCM
	 UTVMUNDqtE/I3UqqIRibXG+c/0vzFycV+Mo5iuc2gtUq56iR+X6GKZwGLSvYFX9FCM
	 Axg2TnM6TObx7sARpC9tLrKUhFKg5bLXy2fjiPc30k5/FQuze9eG5WZbeK/YwZ4P0D
	 nJoltkXEu14Vt+EuDeRamO1iesLgpWanlwPD3LYFHmoyE1njqo81dGYYzv5K33ChAA
	 Guo42yP+3yBmgdH3PVhGebTiUpM3KBSYFEmVkEIi3arR3/bmLNLT9Nv0sgIOq6Fuf7
	 Qywznk0Meef2w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 06 Feb 2026 22:10:48 +0100
Subject: [PATCH v2 02/11] rust: xarray: add debug format for `StoreError`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-xarray-entry-send-v2-2-91c41673fd30@kernel.org>
References: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
In-Reply-To: <20260206-xarray-entry-send-v2-0-91c41673fd30@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1047; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=QeBXOf7iICj0Ad5qHcIJv0VhQMqjDmVdKEV04oiCJGE=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBphljieWZ/1recsKiHHbZ5uEHZHRV0mZOSAv6KA
 uaHTggj9BaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYZY4gAKCRDhuBo+eShj
 d+W1D/4qt398Xrr2oiXr1+jJpcY7mmP72uBRCYxORQ81s2Mg+hCY+dAEYH+h9DRbrOawMCh8S3h
 tz+sMTQFlhUYRHxzdWcgEPxQgBjbjwLytQQskg5tZE/GJFFns3m/EQxCgK0d9HVlp5PmjF1qZvU
 dExZSDPgvbQ8UjCDfxbwSAUUU5qku5iX3wgHImyOVdv1PUOAcQGfIx3Zb0qnzq8WL2IV9SXEXG0
 Mbie9op8xNV2Qu2Nsfph3OXvMjmFDU4LHW7ygdY8i//zLFJsvD89PGqfLW9wPb+ayY2nB5Dbmcy
 8goorUjz/oROTOGXemqz0sfwTcxXQ7A+TD85yjdo5C9Mqm0FZtfVgLzk5ln8TUN+IdEdsdy1XHW
 rDuT+RgGOG7fSX3vAMAFShjyZL4pd1AkDE1yZnweQiVb8yff3mGyfoUxiuAVHP8KWePekmzYZV+
 TePzTqSSMpS1VKz6WmCihK/aU1DesDX177pCT/8iLrmmeR6o2YYi5NvVQdjj+oY+Oib0FvpwMRm
 Ur/l4cHjZ/hZVxNFvlHXaI6xlytrl3P7TeRjcLE2XIJ5c81YdFhKGG/m0J/j0KyQAlfAAvbuAXq
 CObOyfvdTDBR0T5B06gg7md3kl4q78WAhH157iiR2ox9w+KOOMqBBzU2nVJXz6LR5TrkSVl2l2L
 lPaBWzFXq9nxaRA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F31D8C0006
X-Stat-Signature: f8xsfxogfyfc5568axz6bk6j7k3w7ccs
X-Rspam-User: 
X-HE-Tag: 1770412337-704634
X-HE-Meta: U2FsdGVkX18h87ycMjXZ0rmm5oFNckpOnPp8WiOMan6FaoWNvhu5kqA3aNdLtX/m6HhE/2pBkcLwdVJvc6GvNxdgkjL8yccy7tQvEp+O7y/KthBgBoFpHAiXO3lvyamyIRBdLjzw/ZSl9Ncf8TTzMzrKKN9avB4alxd4OlCknrVV15WXDOlGbE4k9JBEIqV2Qjn3vn9PrLfsyubAPL7ernj+CmFmq1SKUXQ7+nskGiv4AuAOgn5L3G0kqNp403o4wGYwVAZy9RHGj3DDfI7xwV8TbQhQwc2IZr8OQ6uHeMAc7gL+NhHDCeADr8t2n3iDpxCIMt2iMOl2GX5bsEesuLpuHhTLIp0ZE6JY3Qc9ocOxtmC0/PydCDhJ6Fl106fScsPYFVIDbJ4m3uKfb0z51oeKVhGPjDDo1XUL9zLQ9ZJBUqSG3aQTG1eM+LCNzSVI3wxXT8jE009bpt7b+UgWBBjyMNzOYPHqWFiqA4xLuTLLMD5i8gbSbokAAu3SxIOMCrf1NubDjWy4eJe+OU0jTsVJawGk//IAWAigJjzGbgoSo4dLT7Po66VCApI2CNNDj7JJMcTb8R8BxWM9cY1h5ft8HzD+a2j9yfyt4+neRhBp9F4CXxe9Y2hauHMezLLBNaq2fc77La7jmf4q8RlZHK5nfSLuwjvIwMCjDxd1qkgCGl1kXOElRxb14VzEdsnSjDLj9hi9D0+p83woUb/lYS1B8orvG0KzUX4hV3W1SLvbEEdfY5w8KHmjieFbuH5QBQnf4Sjl7gMErT+kaz4W0DhAkDIRWIe3LF3Vwuhga4gbLB+XNBWrYRPpVt7k411esj5R/2wvnDxkCeFtWcS78bgru5SY9DMhZlO0nP7b7dXSvb1pdEEqAX5DuhvQZ6C1QlaYhDScmRPiGNh3aNmYIJE1BtAUE/EKVGAOJPRq71Mln6NiTbI+s3+r0NNcj0N82MfCyfIF2Qx7m9y1hpf
 1bUYMFhO
 yjh52kybDhS9dIJCu3UxdjprFq8avM1URuqMdCw6z0gwHloqWE9I7mvbBloAuYCqEnlYHrHXg3klEhUy7pb/HJ6ao6XIywoJiqLSHy0H3pBVBXBrNNVqFnN8i1Gor3Y8eFQzsH/9XB7p3sPoB8BwUvJg5+pqs+Iy/5JSU9AUaGBMh+oatEULmfFi+c0pZzWp3TYYlVcL4MuQ3y9sPmHZEUYtmCM/D9XV2b/FEPd4gw+pFZZWcEe0ZgNXg0AkdQaC2QAVkdaj7Iun23pe4A2OKf9oPdy6E9RnwjU2JPo+IWAkMC5+uQkXmtP+f4cru8/1SHqt9m9JPL4LisPco/MyqPGyNPntn2ELm+RFmdBUU3en0v8G/yNny+RZGM1punoG02sX7tf2IAUlrpaF+akqr4VyZ4VrPlbXArhndbtOYwhRrDHzPuaZTGWtGyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a `Debug` implementation for `StoreError<T>` to enable better error
reporting and debugging. The implementation only displays the `error`
field and omits the `value` field, as `T` may not implement `Debug`.

Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 88625c9abf4ef..d9762c6bef19c 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -193,6 +193,14 @@ pub struct StoreError<T> {
     pub value: T,
 }
 
+impl<T> core::fmt::Debug for StoreError<T> {
+    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
+        f.debug_struct("StoreError")
+            .field("error", &self.error)
+            .finish()
+    }
+}
+
 impl<T> From<StoreError<T>> for Error {
     fn from(value: StoreError<T>) -> Self {
         value.error

-- 
2.51.2



