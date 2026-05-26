Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3C0CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E786B00BC; Tue, 26 May 2026 09:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15E56B00BD; Tue, 26 May 2026 09:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04236B00C0; Tue, 26 May 2026 09:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF97B6B00BC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7954AA0357
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:25 +0000 (UTC)
X-FDA: 84809592210.21.DD996ED
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E74016000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V F1Kady";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=elYBKXJy;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r95UsN6POXemku+UEWA0RutW8+SVMPDyy6AAJkPaa+o=;
	b=stCKxvZQTd4d73eGyFcfrB5wZ16HP4zeOU9gSaS+aCIckrN7ulgS9xEoKwNQDfMocnT/Le
	PvV8APNwTcv+OTjNeFdWwY0vOnd6Qaqfi4Fhe/kK39PYSOWO91MiUOQhx114uAncmse/OA
	MojF+EIM4clHX5+bx1PIsz7z/A/Jbpo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V F1Kady";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=elYBKXJy;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800723; a=rsa-sha256;
	cv=none;
	b=wgU8JIi/5F0TwEgQMRCB2S0tWKNK9MYm7/3HNYz+fCMBRxfigx9vVp6BhwAw3TOx1qLAIC
	rwf2HUWnLIGgobTLLAqwqO+xwi8OmwsBfzh9rUs1tBcDyOS5HmWZPa81Ke454Mv2SmmkLG
	tg6KiSFSTnBC8+FfAc/ZO1qQthFs9V8=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 50A181D00133;
	Tue, 26 May 2026 09:05:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 26 May 2026 09:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800722; x=
	1779887122; bh=r95UsN6POXemku+UEWA0RutW8+SVMPDyy6AAJkPaa+o=; b=V
	F1KadyIFrAFs18cLg3xDeNj8DTmmqk/dwKRM8dgHcgEn8PKLRNcGqwBPbJXRcqQd
	KBVdnbfmW37mrwQXmOo9IMC2j+flCz5JR7jiGBc3rzss4ocIZwGbhC86NaCFkBqf
	fpM4voOh+LyZGaBgaef8gCn2GTYSbcrQTTMsi9l2pOKDujX1LR9qeoH10DPufiOA
	UIOMwu/yTu3hh8M/Q5QhU6Pq21HabEiCMDo/vrXBQACK5I/Wjszb6PH0I9G8IJZL
	+nwfYJuq1uhOr54POH0Ib0brEydYBovCLasy4BL+4DAS2Fu9ezE6nxW8nXFRUYiH
	80tbQbIjSESTqvMPu73fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800722; x=1779887122; bh=r
	95UsN6POXemku+UEWA0RutW8+SVMPDyy6AAJkPaa+o=; b=elYBKXJyH+kc564cM
	gSloRSWrjMp8j9e53ZdkrSnzIB6uLXipuMkEvAVkMwrcjMrSicTeUpHj52Sjt9eC
	K1v400OgBdqB6e1YGrU+5vz3RMtayny3XVlqhO03ZsMNTQRCQLvWNlmqNA6Py5IX
	YENhi+aFTDYPEMyP49STAgtVZfT/juPGCQtjDM1MlafZr3uwzkGSwdcrZSmgp/4+
	st4NRwt9GH8Sx9sG8gaIGREoK0XHe/djFxhvYqVsAtPTKcuEmwewK+3k0l2VyfSG
	a0ia4zbHlfxCBF1piKMH79emsuwn9RetK0fJdyQ8dR6p1Za6B8FRStMU0l5C9Tn4
	f61nA==
X-ME-Sender: <xms:kZoVajpZPxHSQdfnkxClwxMW3UQSkq9u61eyDVQW_AHDk_ZcKa1pmw>
    <xme:kZoVauvQS7e3qLndYdXgBQt6d3IInM9JyUKwOTFMH72WJFd5InPD-yi9KbqK3Rejp
    Xa6WTzkzRAndKbx3aEPcM9RtoLKcXYAq63cU7Mx8jsn3MFKIUmoezE>
X-ME-Received: <xmr:kZoVajLrJsJ_s6OvtPGQytQLgHx0u9WWmz-9jvWQfptXAPLoFiFCLca7aNSKZg>
X-ME-Proxy-Cause: dmFkZTGhhOzazjqDbg84kXmGQIriAJ7A5ZgfZ0KyuPxd944l9VDoz0auYhNa1nywHIJo+A
    1950kHkKTkQx9lnfSbZcx/S8Mcmt8P0l8Wb8fN0f+wGCwnBkoWy9vl20eCC3tZZX+sH7av
    Dlxe1oS29Zt+/zoZFzy+yh5aDbHDzc3iUaHQ8s1Xon6Q6ulUL8z0cPYFRnxsd9cUuaOOeC
    grd5OyNgyo2h51fT3APjemmY7PM1ZW9p43vVXIU5xFLcMabfv/O6RwCJbL3XPnw5Oz6kjj
    h/H6ZW2FJischjgbFlb1Y+t4mjYQn8Uqjf0DstcwPvag6qa0D5BtHhYNV9zEgkVoBIpvlo
    i28QZ3xpuMeXkG9Vo0bwb0QNEzHuzfMOai+QEeiDGLl0K7ZTiv6YICoJ4SHacwXkuePeN7
    r78GLR0pW7mJoP9mv/y78Jxzi+EC/jBx5wAG6ygsuZlgXZYVWgbUSsbWfWQnjCeQrbw7qr
    AIpgRyPKxu2MXhtXDmQwFKFE5SgLyyTyiI0IcHS0ZGprqwj+wV3hSqdL8JLbZUdOZlYUVW
    s4W3dUFc2Up2R4BE6+/kRMIUPJwIMit82TsK0X37VG6bQsilv5FrMfL7vpkUPl7SzhT1Mg
    D1FM9brZTa9uvb7rhT2NDTubSOHN5pgdmYEzm1XL6vPT9sAi73w3kw6YefRg
X-ME-Proxy: <xmx:kZoVaklW0yJGKg4RzKy276Q0fKITmOIo0e8sVjv9ChzSV7Zt2tQBXQ>
    <xmx:kZoVaroOHqtTCvgTcF8zG1jOYMcetoQdQpRjePQyHpngNHoIOo8XxA>
    <xmx:kZoVauD5wya-Xu04ooHva_LN2HyV_VwgA3aFK-1jX5-zI-Q_pq_2yQ>
    <xmx:kZoVaqb8NFm-uYnuQ2siyhj-maCH1Ymp8hdrwZEbthzqHmT7xFEtlg>
    <xmx:kpoVaikBJxWpCMY4NBoAOstsmk39XR43rel7l_SliLwG5mn-7tzfYBc3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:21 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>
Subject: [PATCH v5 02/18] mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD downgrade
Date: Tue, 26 May 2026 14:04:50 +0100
Message-ID: <20260526130509.2748441-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E74016000D
X-Stat-Signature: eqp61g4e7pwinxz7fw5sczunynjgkstk
X-Rspam-User: 
X-HE-Tag: 1779800723-646709
X-HE-Meta: U2FsdGVkX1/59xwrVdOVl8q4i2IiWpET88P6Fs8PzACfwnhIRAtyxBZ5aEcyMOdL1dxnPC7jaE1gnIBX8w9fw0irTPL/8PHyd6JhbwnnDqujYNPHx5DoDCEJ2eZyvXY5ZgpCUShlLXXKhH0c5L3aP22jvzFMFGk43HgrN+nOQWPk8g7IhSuzfytfAEkN46fnL8tGGmr4pmh1tgLIIt9thl57rgxFUWaHyRm72hOSb1Lg9vQjG5MGeIcWEZzRnZvt9JfXjAx2uqCXSbijcgLP8hsXBRQyUj5vKv9ZouaBnRUqoEg3/8zOQaPbeEaaiYOr6ZS9VyMvADKdh+XEJK8ft74u9RMkUzTXiJYUplWNEyNilHjxkZG/QZVV4zifeTf6unDOINRs0mMmc09Lrq4v0AovpdT5PsPkWFopjS7s3Z+NgE9SQpRdyghVElvQt++PgKfoxZQKKBehW3WEI0n4doRajj/Ia2NDajDQ5j7OM6D/R7FYiq5SpKQLi4hl/rrAc+P30XqV0npig1/5XBh1aN+lPr2qeQqT7Dwk3OY7shL9ZZ0m4QKZ03RS8A8E5cJ/lxiVfXA+5RNx4JTs7rT/mhRHbdRenacjLeTbXoYDDq4n6ZDbcaqtse0toECaQW4xVq7Fr/hhQiA78kd9DRSa0VrdPdxVGdd5+m60SPwbfH8K0TZJqMU2nOXF5MSt5zKsSY672kl6YUE5gj58yH4g+4lDHxH+8fhWIrjS18BvvLhQDqE5Cxd57OhnU/NNsIsBPW0TOrcjME5+VqwJhX8ZibUPmXAiBGuWsXVwvpse82EAdXnc59ebXH45gK7reDFuHSl43gGEqryGXVoAURQBNepRrM74lGIKuYJnhA69PJ4jyyCopvqFJytDiQ2RmqOCncCXz/TqUx3QjNzxbTyj1j2p7ZBO1vs/dZMfcMXjN18frpG3eFpVzwjneuYKK5kF7HJGphiT8oG90VFoWzO
 5Pg6OOZu
 PlX8L+Ll9HmsIpdG+Gs90456eMRdLkdcSYGXjwAJxw6Ji+mmKGTe+xa4KFam19TQurGz8Nui1MPTUsxOABsMeSYqug/l14jUy9kf9lnrsLzEu2yEdb4cqAeNfhfPIffZKmQ+LrGcMrgphxepCc84RwS5ReoixDEvkXc4oL1fBuFm1x41Gqt5P5hf7Sh9M1KikPtC0ReokqBmt2n8ln5lXAeRMt7q0XdJ56lraq1bN2zeFt6w0qOYLHniiBpUrVytvDZAIPpRCEu/dsROlZP6l8WzsLqO6HUNbNY8CXzyEuu1QDto7c7jqJ3gN8AKgqlSHd1RzndnH8QDb8usi2xmrJFcFwlVIdz3QE92fOLiOzBZ5rlygToAhs038CUHGk6TqhoX/AUIjn9mz9BNJFxBqAoqlk/4sYZZwqUOrSVRi+YFjbfDYWJ6gXUXJghmc7T0vt3ZLCvjDKCeWrsL1w00BJk1BFJQE1YYT0u7YtVw4PNHU78Sug4wYCXWVhH8FoEfGNi6ZT69KVNrSQ3ALJrEV4mE1L1zCz+v8HZ+mRKaJYBD5A/M05cbJf59bj0rTHeEiwXrA+1dq6ptUvAAp+XNm/vYWzbX/hno2IJ13s3/fLSLYQIJwajoXm1RdzXx6vRH4P0zAsvURtr4orX/oJHpbq7Es1elMXYUWzYQKMFGNHzLp0SfvhUa4V6BSyGbPzf2n0yXg/fFs0v4fACE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

change_non_present_huge_pmd() rewrites a writable device-private PMD
swap entry into a readable one without carrying pmd_swp_uffd_wp()
across. The PTE-level change_softleaf_pte() does this correctly;
mirror that here, matching what copy_huge_pmd() does for the fork
path. Without the carry, a plain mprotect() over a UFFD_WP-marked
device-private THP strips the bit and the trap is bypassed on
swap-in.

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 42b86e8ab7c0..b7c895b1d366 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2663,6 +2663,8 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 	} else if (softleaf_is_device_private_write(entry)) {
 		entry = make_readable_device_private_entry(swp_offset(entry));
 		newpmd = swp_entry_to_pmd(entry);
+		if (pmd_swp_uffd_wp(*pmd))
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
 	} else {
 		newpmd = *pmd;
 	}
-- 
2.54.0


