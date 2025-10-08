Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FF7CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFB98E0017; Wed,  8 Oct 2025 08:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169488E0002; Wed,  8 Oct 2025 08:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FD48E0017; Wed,  8 Oct 2025 08:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E96258E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:47:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E7ABC0559
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:28 +0000 (UTC)
X-FDA: 83974922976.24.3404572
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1F9B12000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=MgT5Yb+L;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.147 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759927646; a=rsa-sha256;
	cv=none;
	b=rfndFQfEwKoySt6QvPuJgnp4EgK6laPTjxIYk7VeMZ80X+VhOuusB4ha4A1kbHAKnebftE
	iCFQptxzyaHZ4iBRVJS0+ZCtL4wa0HUEDEazCq1nBWUxD+kqJ3I/ox0hdULn//D9ewnNTN
	QS1eKZfW6LlCO8/ytbocsc+gZfo6CSw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=MgT5Yb+L;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.147 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759927646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sx8MdAac7N2yRtDh9OtiumveZ9iIOg++0ZjBT22o1ik=;
	b=yAYg6WxhSeeJUrlzmVAYBiF5GJ4hP40AZ7WR6qbjT1DjHiGduMbXyWjdTFkXwoxCnSUe5V
	hx05F+mgN5VzHqm4ieLzCtkhmRDuXfCDZsygnIMx56tcHuXNPRuGx02zvk9K7ZcPntXhdr
	CRn7rFECP30+ljUKUZ8ZO+ACY/g1HtA=
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1b:3715:0:640:1185:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id B3F9480B32;
	Wed, 08 Oct 2025 15:47:24 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LklD46OLveA0-vcNxUOCh;
	Wed, 08 Oct 2025 15:47:23 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=mail; t=1759927643;
	bh=Sx8MdAac7N2yRtDh9OtiumveZ9iIOg++0ZjBT22o1ik=;
	h=Cc:Message-ID:References:Date:In-Reply-To:Subject:To:From;
	b=MgT5Yb+LosHUAisg1Uh1kBtUZGUdnJuH3GhpvLh7WaHR28VkajITt2YoL51B/zxqE
	 YE33Ys3mbPaMaFucKNc028ZZ7sK0jArll4MISoiKSRZuhe1ugiZux/RaZGuLmdHhrV
	 54fq2xS2TSg0SiZ8DsAMhP4257tRZRND03hyavj4=
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: rust-for-linux@vger.kernel.org
Cc: ojeda@kernel.org,
	alex.gaynor@gmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	acourbot@nvidia.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	corbet@lwn.net,
	lyude@redhat.com,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH v2 1/4] rust: xarray: move pointer check into `XArray::new`
Date: Wed,  8 Oct 2025 15:46:16 +0300
Message-ID: <20251008124619.3160-2-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008124619.3160-1-work@onurozkan.dev>
References: <20251008124619.3160-1-work@onurozkan.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1F9B12000A
X-Stat-Signature: cs4kc6ein7st8uqpj1t1x339rexkcr5q
X-HE-Tag: 1759927646-222762
X-HE-Meta: U2FsdGVkX1/oYSF7kovqY519O08wvzt9gREvJULk/eb8TodFJMA3fAjtOb8nmnl3YvyI1MN4s+NGh38RQo3Y4cyJ/fDudq/crie30QGJq8Wd0ackg/dT6voLgVnDjvPFiIE+hbzbeP+j+iWlziu1+4VItAJPxNjQf9tOd88r6jRxQK3Aw3rgR33MCCoJHEql0GybyIH1XmLUV+88nKgrBnx7FvNsZLHcL4otWbHdKfOc90ukKz424dEJ7OiWdEy+uLN5xi3exhjusZHsD6PGtWQfumA9eUjESVKd/GR8nWrI+17/tEzz3IwJ43TzC1LI9v8d12uHuDUuMRCrHLDOnwpQ2Dm4mKkOBSth58oOuge3mlEyt1P/s8XcDXXd+Aj+JTdPyl457DbD6f0CABAGuliAR+4XUea21Cn56SGdZQio9W7iNwHf0u3T8iC6E8GTwGwhvTRdPpfZ5EPlwK3V7SdBcAGLOVWgzTkV7nJNTahl5F8wvBfGk533MQmj6+OOtVPbtBG8JDM6sbuf1lQk4zp4SakCOKvbBtLX0vu/Wlak2w9K7m2+adkTcc9uylsd/DMMj4ka7gc8JdtJGyigPyvSjSY18mNZv3ddSIsjJyJMqcjKRpy4Rk5bTbMh8ie7e2ItPu8B7SOfAYq9OWGX/TDFaoeZNBn9RIGQWtUCzdBj+OpvTDwrch2k4lZjJWhZ7ylN9QCKk9DAT/gM9UjGTjGyYQSeTN+pqfWzW9wmI4yX+EQZS8KXgi0g4CagB3/YwOKkFLuAdoe8vGZZDNJ3TEaxyVoWCtnFV63MHSAm5kC5g6J5WgWgoUDwwc/23lH3XVedMque7qvLA2lRv+/0bLn79wnIazgnL8iSbHV9w7Cq+iK9b8Mb5FJzW5x1GJoVrhkvHdJUAJZv+pRtnWJu0XH5CLMPHJ2vd06WKp04iSAmNZ05pNI//3yF1voAiVF5dijN13R9n4Wz5daAguu
 B92hTeFa
 rkETxYPCHUtb8VXNeUnJP43VWFHnHOr7VK4az+8cPZwBnB7ZXPksNeMdQHfgi32TyiMQoIH6HdXvP1Q2bElCMN48O+vjMkpCoYocrwpxspGlzQKlwLwLM7ytKPg5faPzN9VvH6zxaDFlnCMq51jkfWvzLiBAAw4odbdUYcIsL74QJEux8avEJPiYFjSNFruBvBbruTEve488m5JPtu5zrp5QDp6pDfkcJJBonljs4yBtZiV5lGzR07nVYe8CaR98OOuFqJqOwQwbbRqMkjI01jJ+Z65V1U/APlYL/gD6DyuGqr5/6ru4mU8RtV2cozghStj1xwwb4ypMhsqFwAHZBNB5WkbkqSWDUs2lJGQxIM4qKYV0bRCEHY/hXBuZpZiVNP+BtpuxQojZt0zg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There will be multiple functions that will store into XArray.
It's not ideal to duplicate this check in all of them. Moving it
into the constructor function will remove the need for duplication.

Signed-off-by: Onur Özkan <work@onurozkan.dev>
---
 rust/kernel/xarray.rs | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index a49d6db28845..90e27cd5197e 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -87,6 +87,12 @@ pub enum AllocKind {
 impl<T: ForeignOwnable> XArray<T> {
     /// Creates a new initializer for this type.
     pub fn new(kind: AllocKind) -> impl PinInit<Self> {
+        // Ensure pointers stored in XArray are suitably aligned.
+        build_assert!(
+            T::FOREIGN_ALIGN >= 4,
+            "pointers stored in XArray must be 4-byte aligned"
+        );
+
         let flags = match kind {
             AllocKind::Alloc => bindings::XA_FLAGS_ALLOC,
             AllocKind::Alloc1 => bindings::XA_FLAGS_ALLOC1,
@@ -230,10 +236,6 @@ pub fn store(
         value: T,
         gfp: alloc::Flags,
     ) -> Result<Option<T>, StoreError<T>> {
-        build_assert!(
-            T::FOREIGN_ALIGN >= 4,
-            "pointers stored in XArray must be 4-byte aligned"
-        );
         let new = value.into_foreign();

         let old = {
--
2.51.0


