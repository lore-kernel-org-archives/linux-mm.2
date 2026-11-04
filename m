Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA7E6070310
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ok0iN6uZ
Received: by kanga.kvack.org (Postfix)
	id 115686B05BB; Wed,  4 Nov 2026 14:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ED186B05BC; Wed,  4 Nov 2026 14:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002E56B05C2; Wed,  4 Nov 2026 14:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D24966B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:26:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63778C077B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:26:48 +0000 (UTC)
X-FDA: 85398418896.23.9D2041C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9BFAF40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:26:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ok0iN6uZ;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cd2dCZjA0tUhyc+igqHnY6+9OAULLk3Gm7203fq742M=;
	b=2fY/EbZerWnIwbzj75Mj7I89RZpJUHQDceZZi69r3HplAcmTPVwOWvMWI7KDTFK/ovKia5
	kxxWxmNSsEo89dWv5lpUAstdWzSWDmwmMNLtDFPYUHPCZkEXSFNz+eU6GcGb5+PE2sYNj+
	ioa+ZT/3ulih3mimmH1yzDRlpnVFOzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820406;
	b=wkJq2BakO4It3rdWtrptYiIhCMsAGLhIeEOpDkvIRPCrDhuO35PtzONQpLOpYr5AXOGYLn
	WyCRoES9gux71D0YqwbB2VR0SDw0MlEdkJmUKuY1UE8FE3cVyv0cy6lGotleu9XAitrT2G
	1FiY44F18/Y91ybtNgayXt+PCEkmsJU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ok0iN6uZ;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7E7F404B8;
	Wed,  4 Nov 2026 19:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BE81F000C1;
	Wed,  4 Nov 2026 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820405;
	bh=cd2dCZjA0tUhyc+igqHnY6+9OAULLk3Gm7203fq742M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ok0iN6uZQVSYaoCJ8QVSJT8l0lXYmNP35ncQljCwM9H9v59k+rKBWDwXyFuH6JO+M
	 V+A/kQXQfWgbGohORmoO87IV8G5a3EeicQ9/77UKK7TnPSNtklntEWp/u4+8ZixD0c
	 bRD3pYtw6zhIWR1FS+A6aVjGwZINr1WSqex7QK4NXh4aMIjo3IjIJsUG8/xkIzVtfH
	 6o2/KO4Dtfl777uLHIT6W89DNE9MAKgRdxN0CGLmaTZrAGaPjU++EC952vB7Nwp+HX
	 +JJQg7IqWsBi5yUZmEzjETxgVGZ58lqdaOlqsnXdyQP64dFRJssogaTbhl3zVphWpc
	 sA8Q19qZfKV8A==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 43/51] powerpc/pseries/lparcfg: return h_get_ppp()'s status as a long
Date: Wed,  4 Nov 2026 20:26:31 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-43-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1751; i=brauner@kernel.org; h=from:subject:message-id; bh=sCHTY4Gek8l3mLAy0sLNwHA69+qK9OBjRO3AuZdnaeo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bmJIPL5OsslnfcA9hxcbt6X7Pli9ZcIKN0trZ+9tW 8ub7XmfdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykQojhn5Lb2YKPu5tvWS/Q sTtlvpG7vLPqxuJNXEniS7v7VbrqjRkZ/oRc3st548nj6x0rtvtHXl6Vli/7IVk4c/HNJ0nM2So V7AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: nugerkehmb4znps15f4aw6x7uzzf197i
X-Rspamd-Queue-Id: 9BFAF40003
X-Rspam-User: 
X-HE-Tag: 1793820406-267176
X-HE-Meta: U2FsdGVkX1+xfk1S2VitnOuuFedUF9+OvCsSRGLDQnATkhThjkFOIf4RIr+j1VHyKSifzlhpATZTIJSi6XTN/xwrEKss0QNxSewpxxy37VoglcKQmz0oFW8Rb2i1JJxhgGPoKJohOF1QffPELkrtofgfxsm9ERoRbLKu6Auez3LSaldVDhk/jOk8faixj8jwSz5TpgY15rCYj8ni2/J8kiFTI3SuWBe0VEBXmyacwG7a0sNnRa4VdP0JfQloPER7PwRm9xZxleLdSmWjehutWGczVW6cNW2MOJui7N/Vl5ojqspUEEmDXUrdS8od9aexEG6M0vaTO7aYxcgIs2qnk19su4XFR0QnlPJ+8PfHkYkh/RjIebhCGAKsg5lnakFxwVBWMJVz9C6qsgGxaYT1OGzpx2Jpv5aE/KFQWxHJnrJkxJS7RXdFnaV6Ui+JTM0DjDD344xAigL4hF8wh0zh3vi0QCfIZ0GLIbxk4rd4VL6M2vgvD4Es5/KM2AIr6x8xA7ENpTEwTIs1NPR4GLT0jUSMiHWFfcxP953uy0qjb7bg9I6EmFHF3ukXCu6XOCEKADqaBnBaiLlM+wB6DlPpdmQu5xmaevpBM1CGCMKSI4b/HdyReihVIyB3rR0nMV9ufLGTE0qqsGaq+dV1CHSaL71F5tFqnVfqIWmn3wNb16zKrCP+kmqaPrpz9t0mjHK00lCbXCF+5C3HE2+jEferWO4PN1WhJGNoss9ROaVn2NHhoivjbPO9q0HzvZNPc/9mgNVW5+0KTyanQLleOBIzyLwhyfGjOs9ZvixwjSZvF2ks0jROvoy1AgM78MMtmID2LnluJ3yfbUd4d5cRnrBRkk6yjBMv0y+GhWdQ5cN+d03fyjpxJc3qKkPnSwYqv7S2aqIqO3hI4LGe2zHxegIsfwVWssQeTi+R1nV+U8qE+zpSgdsAAa08CszrUFu77EvzAnGfT9w1JpSCcwr3dIs
 RMjkep4D
 7jSzNluZKbX4+NTeTjnasdfLS2pnpXl48vkoLKPQthuj2Mfr6DXoVQPGoAObMT+Ek6J5ygWLuer+4gsYXnC046gHnVKcjulSDDIBuTz89ufFSSlV54Yrd79oqjSBRWq8nOW2gagc7wHjAFdaOPKZWfvhhFE1kNrCVTjTHRoKs5Sym2aFoUCkbEf0DhoU7Gw4byzFByotrNlZZ2HkYK3zq8LOQHG7ND4oKwt6MdNOFmOHUHHDeCRqARsfu+9uDcHnOA817xf1ozitntkwIHJCxhYPilu3ZavfcgbAczx+udKZjnGMUU5/riTDB+mUerh/FRf3Hb4RmwOLP5qY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

h_get_ppp() returns the status of the H_GET_PPP hcall as an unsigned
int. update_ppp() hands it on as its ssize_t result, and
lparcfg_write() turns the hcall statuses it knows into an errno and
returns anything else as it is. So when H_GET_PPP fails, say with
H_PARAMETER (-4), the status comes back as 4294967292 and a write to
/proc/powerpc/lparcfg reports that many bytes written.

Return the status as the long it is. lparcfg_write() then treats it
like the status of H_SET_PPP: an unknown error status is at least
negative, and one of the positive long-busy statuses comes back as a
byte count, as it does for H_SET_PPP already. Before commit
11529396ea31 ("powerpc/pseries: Split processor entitlement retrieval
and gathering to helper routines") a failed H_GET_PPP turned into -EIO.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 11529396ea31 ("powerpc/pseries: Split processor entitlement retrieval and gathering to helper routines")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 9882f98c0efb..4f6b2975c6e9 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -113,7 +113,7 @@ struct hvcall_ppp_data {
  *	          XXXXXX - Entitled procs capacity % available to the
  *			   partitions pool.
  */
-static unsigned int h_get_ppp(struct hvcall_ppp_data *ppp_data)
+static long h_get_ppp(struct hvcall_ppp_data *ppp_data)
 {
 	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE] = {0};
 	long rc;

-- 
2.53.0


