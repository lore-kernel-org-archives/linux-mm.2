Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD84ECCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 15:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E508E000A; Fri,  3 Oct 2025 11:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2461C8E0009; Fri,  3 Oct 2025 11:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1353F8E000A; Fri,  3 Oct 2025 11:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 010168E0009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:58:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92545878D5
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:58:17 +0000 (UTC)
X-FDA: 83957259834.12.CE682BA
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9D6D840005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 15:58:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=UJBzJmLg;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ATdM4+O4;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759507095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ylh0+79jh+5mpu0rkNzXh0nSiVx9FUZ19dIaYAtmCkQ=;
	b=VEGQOVAU8ujgLWhWAi05C2hpCzAyE9ZRFCwDsQMQLxA510fLSaFNp1iiYoCazW5a0fYyvt
	m8t/JcUaWfWYiPWMQ0DAfmftEMhjqc/G+zabfsie2G1S4DmFL3+a/fF0UvZa3vTE7e/Fc9
	gIl+EsTm0I9Go1cgWuAu1EJUDOu6Bsc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759507095; a=rsa-sha256;
	cv=none;
	b=qvD0oWLuK/XwA9XYwr/KPlUcf4fQniv3mbzC6boxQs4r3WwEKtFfjS12AJ9ZBROO4pUaGs
	AgLEg537+TA0xwoJXSHmhhuz/GXTlr0g2FvHX01pLGq7N3Fy2SB4y6/b/1hbDCVnMCEnAE
	cyiWU35EpHcJUKS+fvQr8skU24pD3HQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=UJBzJmLg;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=ATdM4+O4;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D4A5414001CD;
	Fri,  3 Oct 2025 11:58:14 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 03 Oct 2025 11:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1759507094; x=1759593494; bh=ylh0+79jh+
	5mpu0rkNzXh0nSiVx9FUZ19dIaYAtmCkQ=; b=UJBzJmLgw+FRSbvaBJ+EjBjXba
	rglrv7Zecm9n6giqAjtF5D1XTb2jaS+ll/0+swxIOpJEuvLiPj6WmTyKEy/WLnnR
	mzGavQzRibKtQFiYP8EGGzip5Ak0rCmEPOxgpAqjVLEMqSu9yxpt5X5l5Zom6hjM
	nU23b0wVu7rMwc56OsronBG65Rc+rUcL7S35yoF0TaLJS2wAqnPwR1kD95DrkVXt
	eFkRBl+6dP9VUlOCcMbJApU6olp0+YQzYGZ5tQ91ter6Osnt5B5Aq7v2rD6h4iy0
	wARIISpmH67/riYXvAeq9jO04+F0C5UYMKOTPSJLqzQ2q3XyWUrE+3t5nStw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759507094; x=1759593494; bh=ylh0+79jh+5mpu0rkNzXh0nSiVx9FUZ19dI
	aYAtmCkQ=; b=ATdM4+O4C/v7iL6osVt5k7JYJQlXHk+1NJir24QEPmRGAJOQRp5
	k6hGBAQsWgTMnybbtr21T1Xh+C0Lde8z6hCkgZlPPmHSt2B5EsYUnhPikWsg1ffR
	m1L95YEWQ5meKkgiFXSO1OFmwKUPuVkJHPHpe3Xqf9fYV+D0UF32FJ2ofjg7mJBw
	I7g5PkiComP72q5hwJ5ytA77ikilrSSE29JlFIirr56KD4rquqh/DUnNJ69Fl/pI
	E0KgMpholkKlSjzxeCc6kQzHGeaE77+0hAcv3wWQAdteD9jMOP/jcEfnGdbOm0IC
	Iwh4GLUDRMEo0DpVwF0OAO3jGLdMnhbz1CA==
X-ME-Sender: <xms:lfLfaI2chILEw53jXpxx5R1s1OVdWI9x4bM8SwCfB-OVQfiNCQqtoQ>
    <xme:lfLfaNdqTtZg4Ug1wwVOlGEuNTpSGcwbslFiiDACNpH8sOyWLeIDKSn1-X9lgPFNn
    ERS2V1rJ5ghdbIwqlurRPUoUIuandC3eZxYdft5D5Ww-5C5OwygVIE>
X-ME-Received: <xmr:lfLfaHBHW1BN39WVR32eF_BUy-_NZ0k1k1YYkNI-vH3eUDxhkE6aE5BCefGkZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekleefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfuhhhu
    thhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrg
    htthgvrhhnpeetffduudehveejfedugeektddtvedthfehfeehteffleetieevhedvfeeg
    tdehfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudehpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnug
    grthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhr
    tghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    pehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthho
    pehmhhhotghkohesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqmhhmsehkvh
    grtghkrdhorhhg
X-ME-Proxy: <xmx:lfLfaM8us08O5kadM5KWraGec6JOwJhvJK8-TyyBLtkYgaoxy4xFQQ>
    <xmx:lfLfaDrtVyht5daTJ5vFnV33G2l_q98DjH_ghIEPLemZSLy3wE_Xng>
    <xmx:lfLfaOGQtF3UhGXG54DibiYKDEhYsiWofdMrMPseH3KpCavW0juYbQ>
    <xmx:lfLfaP9FWy5vS5B4H3ULDMIuKG4T88hEpjZVXbYmI9-LgUM5cc7mZA>
    <xmx:lvLfaP4SUwVoXDHfcC5-eR-MdGX4p2WOJ4AXyl2zEmPkQRQhDpNKfvph>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 11:58:13 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	stable@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] mm/mmap: Fix fsnotify_mmap_perm() call in vm_mmap_pgoff()
Date: Fri,  3 Oct 2025 16:58:04 +0100
Message-ID: <20251003155804.1571242-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qmki755ujytw4f4jikah79tijykh67ob
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D6D840005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759507095-386136
X-HE-Meta: U2FsdGVkX1+cF2AP8ewt5Pxp2HSCKvFEAIMb23u6LpcRCU/93r2cCQwilN078ntl4Hbr0b18KW6GBYVPV6Eiy8TOrWxS9ZrhzAw6PYQlwKlJfbEpeDuGykUb67VzaiEDBXPQJujMHlnpdIZk6MKN9kOFqGGRKn/LxqRrOuV79SUOjbI8/HzSZwh1qoQ8p40kS6K9nMz0KvKoTXt5FMuHce8Ntd6UtdFt7fxS8pvqKFI58pU2G5T6lbccemwTiDW3MLfgIGF2lo9cTbN6o0x9M5n5bq1NImRvDpz6idIcuWJUD+7acRB/aeDHx259vBlWXphrKFtnLddPMYI+6kAUDF7kwFVXV4XjyJSu8IHsgF1LOkB+eg41VttjN0kcainRsDqkY7uhKczYQxoDbkc9g3zTwtes55WJIsWvHObRlTNiGmAvU9YkinyLimTUJZ6sTtdUVTmAbWPdGaoYIyikP5tMZ71PYNPJsmqMPlz1LVskSgEtFZkYDs0iGFCoEZKwKBLCx8uicQMTFQPDjDYhs0QbYFkjDcR1p5UWcd+gJswb0kLhJW2NCjiLH0Yrew18kj7w6qgvUW6vA5ysfacnsf1TbJJ7es8mBJWGZFTomBhx3zgCMg+cwxeCxEb6qy2HXF2ZiUr1atv5068qbdMBV1ePFcNEBseFeJURKWHdDfk2pl2ZiwI+uemaFV4oD5ZQQoP0R8pXMUDUw3fKfsG6rsfvNnJkDq3C/uBm3uEaHtt5zJMzBX4pKhvlsLiI+5I+eUJLgufsmDknCHYlp7EhalHH5kwISo58Fv9afAQzjwF1pqObcoX9xhbHcpR+3ogWYS1S/EUPK/ea/F7Lo1K1tJONwwX81TyD1WesnpLnQeU9mD/6inM/rAcW1Pr/OnL7/Ngnw/Ua6D9mIfQAnBGwgNgazMckFxsY+ZOPRM88jbkmxhp7r+ftzOEWjvfK94Tr+ghIQi0bGa3SExJvV8J
 OHxQuoQa
 jfhopeDePiDLSPoafYvk1RvmATdNOoJIZyGMp3RGbbeIG3cCp6EVgRSdzjMsjaiEfv5quL+HbDHGaSqXELL38MSKkHqGTslCJuhOxlgOhOmJj5EMHH9CliONLqfUI4X1wYH0GSD/+xSye9b0YvDlb0gQC4qgHhftA1qi3CcYxA9zKpzX3Ei1WjTVtY6WNXiKRd7fgl8gDvnkJ1qrhy3zDl+ek8yWY2rd7Ko1Wuch7ZqiA5UGwiW2XRjvjKHb6QGyeMxGQZiG0MgvdOPUiU5h14YSrX5oYv5ZIgppNCPHmq1ZJMjCHCeabJS90vVADz7HjCSijwYB8Qzhax2LpDnkCyBhJFASKrojRjIQWhoe61HoUA7bB6XzcNJ1kK4d8/Xi0ra/JIQ9RB/FyZINSo/YPv8K2ZpV54WmU9pteHxkKUsUeEvEK+TViu4YwzrJ7x1673xB1FfJt4mRmL/JcJ76zGD4O6Ydup3BEz+utCA3LcwpHwQj3iPvpaJ2bjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

vm_mmap_pgoff() includes a fsnotify call that allows for pre-content
hooks on mmap().

The fsnotify_mmap_perm() function takes, among other arguments, an
offset in the file in the form of loff_t. However, vm_mmap_pgoff() has
file offset in the form of pgoff. This offset needs to be converted
before being passed to fsnotify_mmap_perm().

The conversion from pgoff to loff_t is incorrect. The pgoff value needs
to be shifted left by PAGE_SHIFT to obtain loff_t, not right.

This issue was identified through code inspection.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
Cc: stable@vger.kernel.org
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 mm/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index f814e6a59ab1..52a667157264 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -573,7 +573,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret)
-		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
+		ret = fsnotify_mmap_perm(file, prot, pgoff << PAGE_SHIFT, len);
 	if (!ret) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
-- 
2.50.1


