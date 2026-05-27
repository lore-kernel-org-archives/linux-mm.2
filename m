Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852A0CD6E44
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E476B00D6; Wed, 27 May 2026 10:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D530E6B00D8; Wed, 27 May 2026 10:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8346B00D9; Wed, 27 May 2026 10:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A95E46B00D6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62C011C1C7E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:24 +0000 (UTC)
X-FDA: 84813369648.11.8D6B531
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id 569F620007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KtuYxwPl;
	spf=pass (imf31.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6e5970dOoz9fKbdnw0tfYlfryhDGT/Rrpa19h5wLuiY=;
	b=5NldDDF0VQZ/1//N7ErGU+xrXcubdRKQvx5p0MAY4xnVYP3BzPbNGi6QYjRAj3vi0QtCdo
	wK05RyyP0vkp5gi8bpSNRTKo8d4S1TYZx2tik/UzwdF4+H9F3xg6BPfJRanejB/H+vlp+N
	PvMimEnVwoiRXgi+dFHmzpqnVP46MRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890662; a=rsa-sha256;
	cv=none;
	b=IpZR0axaUmYPEVeupnWs5KWehgMfdDQnSPUE0QBLeV8mN0A/Zg8+Sku719HnI+dxAU7xYt
	FnladEeu/HdJGLWfidGwcVR4Np4PVTnNQCBzJ7BsFNU45knh/VqlvCWiELBMjrn2YtNg+6
	lkK5v+zEE3v0DBZSgXPZ9rIl1hvYKyc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KtuYxwPl;
	spf=pass (imf31.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d73422431so8369224f8f.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890661; x=1780495461; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6e5970dOoz9fKbdnw0tfYlfryhDGT/Rrpa19h5wLuiY=;
        b=KtuYxwPlTeyRrcAApWK3/qjRVWhmk5ZakenIgnxl7J/QygNdNjvjAyLXoD0oJMDhQL
         H/EQoCsHIBpILT9JD1PikWPOrZzq/zwUurKGRFa7QrdSilga8j6lGabfoMxzFYwhxRMd
         HERc443XAEiQSXhoLxz//S5B9QTdgkX78X5WC3O5PH0oQ9Zzv3LEkHsujsHYQfWuNYN/
         AkEdq7V9QzGKGJESHX07g0pwo/4PN+tIOXzb9qwxOCOfflHIpM7ZlLfTbJdGk/y+Vt2Y
         lio1+6qJSb/ZIvGd6EYlpR/GSjAARDGP2At5dL6rvboo8KLuZPKCckZg8FiEe3Hjeply
         kRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890661; x=1780495461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6e5970dOoz9fKbdnw0tfYlfryhDGT/Rrpa19h5wLuiY=;
        b=Ssg42eFOXW0mEFZSZsg1g5ICSfn5jo42cRVxw3bCfWSmlg3hBUPYZ6HnA99dVOwkJH
         isQySA294z2MXcCK7xqcCaVpBVZIHkoM44XWAUevYi+mrrdhea3aEA4y5w3K24zT4eoJ
         hAm82lBcQNboPiqH8YPrGyIIdkRXRKFmcRc7CxshK8vd6/9DIcy7qPfSZQbX4j5Y1OL/
         Szl1nTdi2/MwtPiwWN9K4lkgynU/zYOT12M+n2vj+K5X2CNqp+2eqgDLwsBkyav2eTGf
         yaxLV4eam8r2FpVV2Nnrt+nijoNr/UNR6AY4xqRSdl781UXhevy/zR15lKeuX9zkZ76l
         HjiA==
X-Forwarded-Encrypted: i=1; AFNElJ8C9lVf7e6BupOIagryM2Yq2RVZgXAuZYVM9dU/cDXuWZeEblyYfM0xIqlOK9HSBPb5fh+i8Zn6PA==@kvack.org
X-Gm-Message-State: AOJu0Yyg6fIfW/i0GdoKclcBP5JgjSotI8UtYYdP2DhGvsbz6t4AUiR9
	9vsGdDZIwFS4f6tSGSnfuRL84m//aeztBAM1alCccMeVitXScOpMh+Sj1Vt8HZ53
X-Gm-Gg: Acq92OG+pwSJEupbNyXk4rsj2lzDehE1x7QUgHGk0eZDaOl2j0i7+qxmJm8ajSo0NYP
	eWPd8wJDOsBqnmSM8Xox9G8AqKvZO6hBbQNQxDIzWrHUTA5W9JWZAPr23fnL+BsbgYCEjoULaBs
	RmpHKGPaz+Q0wsUCWCWMEGRC5Nm+VaKOuWb+SNYGHmQTYRgtNxZVIQkTjTQRRoWLoE1xm4PwipQ
	1iXRC9bYvhhuKboGIF+lsPEpvoYljdiOh/YCloNt2xScs0IKMKQ5/DSehMpTk+nwWEVTK6Gwv1d
	0JxmzetnH0tX69pj709cfgJRhr28JT4EiQ88Cpy2dl79Ju15bWMBMHyChEoWxHu9iUEcCFP1qYO
	+90hA1AixFm+rG84zVXdoKLNMYZs3/WPfKkKg3f+0uSjzP0NDXxIy+MNc8WYTbhmTixkpwftF5r
	8oWrGTk+PtM3ZvxpvR/oks6VmFNz2qPLjtncO81AkrK0B428/s7sZVurwv00vL9ZeelIf4eHpxa
	WFZ1E67tYnJi36iyD8zUT1N84NRfKFKLA==
X-Received: by 2002:a05:6000:4707:b0:45e:75c5:1a6a with SMTP id ffacd0b85a97d-45eb38bcb3fmr37810576f8f.33.1779890660721;
        Wed, 27 May 2026 07:04:20 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:19 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 8/9] x86/xen: Convert xen_mm_pin_all() to ptdescs
Date: Wed, 27 May 2026 15:03:15 +0100
Message-ID: <20260527140316.294621-9-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: bjzy9sjazdwqkp9rrrbd44n7xcorgxca
X-Rspamd-Queue-Id: 569F620007
X-Rspam-User: 
X-HE-Tag: 1779890662-312783
X-HE-Meta: U2FsdGVkX19i9MzPpvPDvo9F3dZWnwrH1bMpOVeqJxxSa4A8xOXTTUSK+I+e91DQGh5Y9shv+x91eYPxDhlQTl6nnxTFo3fCZb+0/PAMrNtSu5xvEbzYBXU6Mbd7xUMSrEkd59QB6jI//k2X6+gUECM0+bRvMfu77T/mBeMeZGkkmQU3p623c4E65jj7J6DmNNCmQp3b/EQ+q/8dDEDRM2iQ6Zx+QNdZYFp0akJagZOf8eXIAHVvkdJrObhTMJ/t5s0K8QUJTme6X78LA1T/Dsi8jipONeObG0KljRz++RAH4zZ2cUqZK+0jmzItYdXzYWSz7tSQGNTtSgbLnnQOTrNr437+76ev0BKkiNKmdLROym9rSAIuge8D3ZNimE0zHQRi/COa5PW7CaF8fgjTRvJX9Z7oo7tMXO4Cl29LIxJhyUhvpkydOrRKJKfKNZi9zaW2yYmcPySGP+qGDBkD3K60BY3YU1cCcgmvTFzAFWBZno/Lu2zMy4fH1pMz7VIlmqbJe+ME++5pboxo3WCd5zdv9uSlJZTG4kit/bpR4qR3D6ElLOaUCWz4Tn/Qo9G0gYDjNMbsZVpL5v0io7vYfYriGwD3YhUB0N4tMk1u6Et66p8W6ZGWuTf3tbM4+rB2g65qpVVosIYsg7/FS/8t3GtiBHT/o8Mxb2WDi599ifH4437JGUXT5PKqIA74Y5Hj5o96Geaqzgiv7CaroYCvFqVi7zwvWlUAT2tbxsbnrIqpeSbpI+Y2d1+3PQXdC88LlpRqpQclJs1I9AodwG00rIpHmG4fEk9TK9001wi+knqVaLhmLv5Jv1emTNbSUHRxMnRRbiWboCbNJOLBEwaPCaBfXu03yiDqtSIhGbP83HSkALuL0Qt5BW2m+L5USj8E0S8pRtsXxzv2e6+5svJcSqlnZJVYlEz4jy0DAr2ScqRpDVK6s2SI0izqyyval+9y7egrBQTLKJL/pdHjt+N
 7R3yq3gS
 ow+qatKb5y/Z4ay331pEPVORLApbkGhjiEdlP8fS029FIvbvAWj5S4VSGm1tUZrx+aI6Bi/J2s1WtDQZGerTrOiNNkCZVZcwaUAyhDz9B5OWFuqlY4QCoSvsLYnITIEh7TpRSrIQ5jNMtfxjSBZ5dzXOUzLXrSkCGczrKqINUJzZu+VXpipfPc2oo44P0ZW98VwWMetMX127kKz/joOdrwVlamxW1U3O+TWOy73SyyliN59zdY02PF1oGBbhNz6qg+4Fg5f6blJPUrNOuJY4X1/TAyfLQTNfX7NvoaHxnMt0L+D4/WxdX+iWX3FwVZHhYVugblMwhHtwv1kybdmVUB+2mFMhoF2Dn5TcGUmjgAfYEvhHvl7kW7ZjZMuYBa66DX3uH9ISVHvHzE9IHzMrnG8GJuj/VvbS75OCLdgk09DaFONFeIjNI4xtHvin12hR8wGitNNHce98mEg5pqOPnU70LSZAtoaBqYeNaDyaiCGHNZUHM0Db8OoPwCb/eO0T72BeWFT1j+doAdRxnRf9xZjNLXDq/MvwUzIJR9r6ahG3MnOoWtpPnruSJgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert xen_mm_pin_all() to ptdescs in preparation for the eventual
splitting of ptdescs from struct page. Continue checking PagePinned
through the underlying page as we do not have a per-memdesc api for
page flags yet.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/xen/mmu_pv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 3eee5f84f8a7..b2f6e7b7c545 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -828,15 +828,15 @@ static void xen_pgd_pin(struct mm_struct *mm)
  */
 void xen_mm_pin_all(void)
 {
-	struct page *page;
+	struct ptdesc *ptdesc;
 
 	spin_lock(&init_mm.page_table_lock);
 	spin_lock(&pgd_lock);
 
-	list_for_each_entry(page, &pgd_list, lru) {
-		if (!PagePinned(page)) {
-			__xen_pgd_pin(&init_mm, (pgd_t *)page_address(page));
-			SetPageSavePinned(page);
+	list_for_each_entry(ptdesc, &pgd_list, pt_list) {
+		if (!PagePinned(ptdesc_page(ptdesc))) {
+			__xen_pgd_pin(&init_mm, (pgd_t *)ptdesc_address(ptdesc));
+			SetPageSavePinned(ptdesc_page(ptdesc));
 		}
 	}
 
-- 
2.54.0


