Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5357BE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0BD6B008A; Wed, 18 Feb 2026 06:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E525A6B008C; Wed, 18 Feb 2026 06:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09D56B0092; Wed, 18 Feb 2026 06:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB8976B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:53:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72A1E1BC50
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:53:49 +0000 (UTC)
X-FDA: 84457418178.02.5C19080
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 97998120006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:53:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bHtO1hdo;
	spf=pass (imf29.hostedemail.com: domain of 3SaiVaQkKCEQgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SaiVaQkKCEQgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771415627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nREefhNbsS6m+NzCv8p/u3MUoT+tS1ddYgBqAgzIBg=;
	b=6u2c/62VXHwUuLkIihqCfFYH/U1BxfqpXefXjYUxGeKyJjpb7ZjJAxDBofj8CNNr/TPJhC
	ZgA1Ux/cCHJD9hUHOKnQBJegjWr82vR9huEOUEPqqCHmtUu/I5DWZeeQB6iIhHpLXY2dI0
	H/N7dq+AstP8iEp6STOv+lpRDLeBWK0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bHtO1hdo;
	spf=pass (imf29.hostedemail.com: domain of 3SaiVaQkKCEQgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SaiVaQkKCEQgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771415627; a=rsa-sha256;
	cv=none;
	b=5ydNZ9L/0v4H4qxhuu6bnn/Iz28U7lVGpr1RhwTYfZvNYVc3Oejhyc0OBzHID7IWFI8XaO
	aNjBqPv2CjIKDNoU5akEKnzf0PZ2LA8FWdgST+WwwsJMjytHkzG91+Cxv7TMbZpkIMfvGB
	RN0O+ycx18ZYyqgItRc9YtvpQ/RuxIs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso29298275e9.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771415626; x=1772020426; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2nREefhNbsS6m+NzCv8p/u3MUoT+tS1ddYgBqAgzIBg=;
        b=bHtO1hdoBQhmrckLrOoABKxOjGXWFcRW43qOyf+NgAzREMBmLTN6M4XCXcR7SC710k
         gZws+PwiTtBQs3cCDd9r4b4jGYi2F3BckZ73Xa8QtWvxCxYoW6EXoxKPpHLuL6tMhTdn
         98mZCPgA2Li/Mc3a5SZNpJf5O9RQiHWJQZWIQhjgmjLz6Dw5yoFxT3KuyltY1dUrhVJ8
         VdyevLJfM45uum0u0x3CM24+vExWhhn03lBSuPFu2w1h1yKoCylwHt+1I8lFgQshycCH
         LhzgrpFlyN23XKJoeMP2f9BnCgUxRiJTbC6V4vFDkxTsciTCG/6WP3KDpu504xrv0Utl
         mueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415626; x=1772020426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2nREefhNbsS6m+NzCv8p/u3MUoT+tS1ddYgBqAgzIBg=;
        b=Zy2cIyfSd6VbeMwXe/BB0JMIReuaY9Do20nATfvm6VBIUd/izSXq/ghbTdjPMDJL4m
         DJF3eE7dOpy/vOlBXjwTk9TdZsI02O7IcV9xvKzyQlHxn4pT9Zv7VmPLzfTjSPoiIk0/
         uDyU3zJG3jrMOdP5DOVkbEdh+11aavjHrUzge1Wq+VasQ2TY6IEwnE6bUaCyetbp2MYc
         gM4AFm2ApEl7dOWz856WbwopUwyvkko8Y8frMDKjExctmzKjXaYwaEgoMCsMMxiiYIkc
         sI/ymIIukqWF0GmUQciLGHED2Nm2P8ouJYmL/t/e+VTvVr/d+NSZg3/kC1jaL1MOHELR
         cu7w==
X-Forwarded-Encrypted: i=1; AJvYcCVnazA/0AMttfJ8JP5fy1VoZG2im5TbLQcoIZJ0yIhHu1zO/b0Sn10/kRYkqwEe01uGyYZDsXCZBg==@kvack.org
X-Gm-Message-State: AOJu0Yy8HN7vrk3Vltc4VKSOBpKlI8SoyvYqDfJM9yXCIJuNGWBWg3K2
	TgbflxClpEVdBbKl3Jzpg4jve7CC1Gt9UqbSkQ8oqheMq586Ljb3KUfuoKWlLpHE6oLki67zgJC
	j3yiUNP7+RYZgJTYgtA==
X-Received: from wmof9.prod.google.com ([2002:a05:600c:44c9:b0:477:988a:7675])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c25:b0:47d:3ead:7440 with SMTP id 5b1f17b1804b1-48379c14606mr212400745e9.32.1771415625987;
 Wed, 18 Feb 2026 03:53:45 -0800 (PST)
Date: Wed, 18 Feb 2026 11:53:27 +0000
In-Reply-To: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
Mime-Version: 1.0
References: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2898; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=dxslJAb5KIt29+Pmlra1MsYzJUsqBlgsseUHaKRC00Q=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBplahFqqe27pmaRIiimlvXAoI7c4Aaeb8gzBCoW
 7sqLygMmP2JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaZWoRQAKCRAEWL7uWMY5
 RiinD/93Hu+5kQo1qJcL+IetJ2vxyhhemT1hfThuvAADi5VceWTgLmJNepFXO7G77pW/2GeTBB3
 hglYyOoUtJStG2fdTUp+EutcYerAtSgpAnbhEpOIaMKO2Yes5W+M92MyD+6fyb2jpTNX29pujW0
 uca1oss6kBre/m26qiICetpHoL1NS1gN7YdP9JmrVujhz3kE+tFIJlMb+hNWp6ai7tdcn4gTSB9
 J9OLQvOEIMk/kiA0xLkm+5Gl/u+m5OBPNotZfvsSwjCFDHFAi76dii3zfnn0ogXbsk8Cng5gEkS
 CK49G2PrS5MB/lyNm8FVpbgDxUbHE4/HJ7qOJv7iBgDtBwkxpeW+4sWHaflHwSkyBMB0o06XkSy
 CcTe+B3ydUvhCe1jg0tUlmuCqtsRcBwEX4XonP13fIL3aJPniOO4Ofg5aT1emcncDjlovMuwzj6
 ChcMKSLOqtG2QV6h2HY6a7qu7ih04BkCqiTbRiQ3zKOKqB29seNh/1VwxImeQ3abXclaS/J87Xd
 uEk0oq0T080GYz/oSMJjJ9jLLpuinmaE6Y6d5KtexouBUr1Z2YA40lB77+roEZf/5v/XL+n/rVc
 Yc/ENTdwPvpAqKsnqxruyi+lhem8Kr5FlqNy93Krvh7d4uqyPNFvWixXuiZrM0Rb+RVZDF1DJ1I F2yQblZRdRGtoHQ==
X-Mailer: b4 0.14.2
Message-ID: <20260218-binder-vma-check-v2-2-60f9d695a990@google.com>
Subject: [PATCH v2 2/2] rust_binder: avoid reading the written value in
 offsets array
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Jann Horn <jannh@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 16zxw4h9f5iatauedhm9rfi8bmdibfh1
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 97998120006
X-HE-Tag: 1771415627-368753
X-HE-Meta: U2FsdGVkX1+n/o9VmY/u2yyVZrMb6dYxfHhN++FbFd6DSJmZS6e9BFOW4yk7K+FfeJWYadbxR51WhGUmgz5+VUMm/VpazQodNG13uRVgOOiWRZGne0Wwq14t/bQ7sdQyzKuD2An/ldfiGEkEvXyhQd5EAGPi3B4R6YWMi0qqYEeBEPXqGPd4r3Cr82jFZEfJW2KtJNAa+pG1SlexvuYhWScMU2dPeyqzOGS9OMPRdOOtBz5lyZVBZ5nEJFKKbDY+ECwt482jBYZgSpjasKzhNyhu9wo+k/cCS/2jsUI+8GJTHTlP9oVeMbgu7kIMvjXvFZb0tTAh/lbDPRkgmhAkMjOlyJKsili7xptCQc+BBXJB+Tb2NAC0U87RRLen/C1uA1FCeJfR5/rhQH6JfFa/WORmL/4jfl3iH/Sa8aaQzXcsZeF9nA4VQrzPmkv3VmS6GuhYCwUCjghPpZbfbgzX3rJCGscvELakQcFH7+QB3zj0gybKaJFoNbYBG+pgXfdd8hsXINDswq/LDFfLi/bWt5I0HflSrdQOlrglacBckb+xyFJoZRfdBvZxQ4zHFklEdcEDUzWbNKT6zo0lS1n3/9sGp5Q3PxfbTpCADQHFASWPWiOso4GwNSfs7txknSLPSLWiK54JKIG1KB9TG08ffNUjgg1yjezsQ/hv7rGJCawgs5saAPK97luy142jkaycRULjk6XlTqZ0m+/1AHJKB75SokC+Qr84j/udLYuVDZiyRAPLXy4bo0Fibciz9u+LzZPa4Bb7M+VfCQ0Dne1R1YvoEMNTjd2sXDfFmNq3204UIrOWej+OM3U/Qajqf77z57u0oDVdPKw3eTs5QiW6KjOmr67TTVQvqy2m58/6R1n6o8p3byNdxZRFvi5NmHQELGgKe8DolxkJGiBIWzTbXsoxl9bftBRC6uang0Ayoav9FHyhAzflYeCELlxofbKNpw5NwL0PtazNryQuMmv
 /0xtcTxD
 X6guX04z/+yLntPSf56odW+6E7VOf7y3Sj+ULoh1v57MhAQw1HWYL1JCOc2CpOaqL9PaVk7/tjW+UIMzeUjnrPut61LUfM0l9NHttRuZuMAdXJPioBem94V5ptQWkmAyvmgGlSCAW7xjobD5GF6thxWCdr3sOmHOj/i5z0RdvJZer1rPZ9+ZbuhB0V4XFH50lFYMI5q5rWbThot8b39Gq/rFUwV+In7C+kaIcGJxnRctWIWhKTVtWPBFA49UNE5YbzJ/ylNJHKJqZwQuv+8rtvvvJjQC18T63NHWRbvbzYCWkQCvQe0jNtUI0Hhbd4zFRqOnHNYi7sH3vr4xFwoFgjDjVuKQorP9dITFE6qo6V16yFmouXjHtO0BEbCriHduay8002FXoq8yjHUSyAq+mqln6GkjItB+SvzKXuTQqHV2M/N418K/67FPcp6euY0MAzxjMVdpAb5jS4jaJQu4QhGX2B191Ev+R/I08OHDy0dYhMDW0bBfu0BpH2XMZ/j9hEW+m+6mnRMpC/HZFBx77u0iwG5e4tM1TQqJ03jdMJ0zd7k8zaB7ZcNoJcjIKJ2cCHjjgQ3CzMO6fmCb24NORzUNogjtNH9W7tRkTj8dCEU4XD3K5A9a+pYtoD1/4TEp9BrB6Klgu6gyvhvg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When sending a transaction, its offsets array is first copied into the
target proc's vma, and then the values are read back from there. This is
normally fine because the vma is a read-only mapping, so the target
process cannot change the value under us.

However, if the target process somehow gains the ability to write to its
own vma, it could change the offset before it's read back, causing the
kernel to misinterpret what the sender meant. If the sender happens to
send a payload with a specific shape, this could in the worst case lead
to the receiver being able to privilege escalate into the sender.

The intent is that gaining the ability to change the read-only vma of
your own process should not be exploitable, so remove this TOCTOU read
even though it's unexploitable without another Binder bug.

Cc: stable@vger.kernel.org
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/thread.rs | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/android/binder/thread.rs b/drivers/android/binder/thread.rs
index 1f1709a6a77abc1c865cc9387e7ba7493448c71d..a81910f4cedf9bf485bf1cf954b95aee6c122cfd 100644
--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -1016,12 +1016,9 @@ pub(crate) fn copy_transaction_data(
 
         // Copy offsets if there are any.
         if offsets_size > 0 {
-            {
-                let mut reader =
-                    UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
-                        .reader();
-                alloc.copy_into(&mut reader, aligned_data_size, offsets_size)?;
-            }
+            let mut offsets_reader =
+                UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
+                    .reader();
 
             let offsets_start = aligned_data_size;
             let offsets_end = aligned_data_size + offsets_size;
@@ -1042,11 +1039,9 @@ pub(crate) fn copy_transaction_data(
                 .step_by(size_of::<u64>())
                 .enumerate()
             {
-                let offset: usize = view
-                    .alloc
-                    .read::<u64>(index_offset)?
-                    .try_into()
-                    .map_err(|_| EINVAL)?;
+                let offset = offsets_reader.read::<u64>()?;
+                view.alloc.write(index_offset, &offset)?;
+                let offset: usize = offset.try_into().map_err(|_| EINVAL)?;
 
                 if offset < end_of_previous_object || !is_aligned(offset, size_of::<u32>()) {
                     pr_warn!("Got transaction with invalid offset.");

-- 
2.53.0.310.g728cabbaf7-goog


