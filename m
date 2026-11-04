Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A904A606D809
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I09Dgc3W
Received: by kanga.kvack.org (Postfix)
	id BDA5B6B00EF; Wed,  4 Nov 2026 14:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B2E6B05B1; Wed,  4 Nov 2026 14:17:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54196B05BA; Wed,  4 Nov 2026 14:17:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 842116B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:17:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14272C07B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:45 +0000 (UTC)
X-FDA: 85398396090.23.287EC81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B4D54000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:17:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I09Dgc3W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dKsu59FtDy8aNyG4WRUkN7aPYhsNBybpSNJpPGyZ1Y=;
	b=6yt+6XsxzeTw972tQInRStgkocdFbJbZ4Hysl+feZifL+NNHZoJ/iwkaWv/zSWxbdbLYiP
	gWcsSg6ucOl0kytQi50sapM2sj/FYbtTJeFPd94qzugTjNYoWt0HS6jG84hfM5vVX+X9su
	dbuNzzCwD8iwn+JOF/gfxBhf8NnfzXc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I09Dgc3W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819863;
	b=hQ8hTgq8c1MuQJ7yrp7R9xsSuPfS0CC3x6/X+VGliy0zBCoLvGuibgjH2PpECvtEFKeD7X
	d+NOoOHTIhXV2Df0KyBtzpsOkWTPoud15PfPy3YbhenLjB/nKHaOZ0b8jTgMQBzcR+2OUk
	1gIKhSqm9NqELtKddDl0sKL34vdwytY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDC1660A66;
	Wed,  4 Nov 2026 19:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF121F00A02;
	Wed,  4 Nov 2026 19:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819862;
	bh=7dKsu59FtDy8aNyG4WRUkN7aPYhsNBybpSNJpPGyZ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I09Dgc3WahkVUkdHZb1ultk0YMkOb02PK1qI6zEJbOi7/+V3zq8fq+cWRfZX05NQG
	 2lA2rqFRv/45g4bPULWMQHffdRExyDxzArc/hYgSBx4eO5MffKe3yy8p97CR46mmmZ
	 9dDXzJEWztjf6EaVEqFVKoidDZJ+7rTAReCBc9+dsxygtzA4VX74eEUMjD1bcfkFu3
	 QYaB8uEysRHzykLP06EUs/1ZqunIBWNogzs/SWlT+hZAEg08JSMeZHXTmY93feNFRf
	 2ZEizdSTdr3U+mIMp0z1pvTgsP0C80x+AxPAiukAaNUo0JSRGMr1Yf0WgHtW4okH6U
	 zKMPB78QEQ4oA==
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
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 06/51] powerpc/pseries: put the node that the ofdt property commands look up
Date: Wed,  4 Nov 2026 20:17:28 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-6-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1735; i=brauner@kernel.org; h=from:subject:message-id; bh=9GgvRCMv4/Dc1Z942cy3A7/ul6cTW5I084eAKnASIT8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bry04VhwqY6ktsHfDTVnr+b4bPJgfc+0lt/P01dek tuWdbdCRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERavjAy7FnwPn/GgnMaE2ec 2t9e+OuRtkX+5sUTRSbzyRQ8OMAzexYjw5M736flveC7KnfK7e6vd6+v/AiwDEi4qz5l7VpJx5c MnYwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5B4D54000C
X-Stat-Signature: k57sptexcbfzpjxtnm1f98par6z9p4nf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819863-803917
X-HE-Meta: U2FsdGVkX1/9lE1GJPVcQymOVujpqqErtYlh1UTLcWd5DXa6UOJcquKxC9ZfX54zl936EHJYUMP3isR/SeM0lLfmRA4CLo5+DhrgcfnxYw9ZK9+UecK1Dpj5VoDXY7IoHmTcrSpWqTrZdQ7uNSOZ1imDzTlcC9tggNAm7L77s4Tcd4q2AnbG4Q8cIWPexcSL8PSISkWTlufaSGVi4smo8AyLSQoNWVVI/hEVh90SbDRwXg3MvJDCnD5Ux7NtRAWYs+YWorvVpUGtcFhSraNXjUYsscp0F1f/RfhPIpqiEX/2T8MmmiYANOb4qvlvJbL6KAYCgWwN6FQFmseeD3PruumvvFxhJfu7M/d4roaE6ja+6PyA9LR/sNpD/9S76CoYNCJIKU+EZ/6h5cdM/LjcyhTaTLuqlne+4hcoU4j8c06t/x4cG8eyFXCLK62PwsJlbp/4h1GFMR/SPJo/+FSHYdxbJmeQndmfzDNc+DLfQaczoLDStRWq34ChmNPtB1Ls9YV2zMt5HLdXFRaFyt6uRB695r2Upc0jEhWAbsR/o7jTsP9guQ/KRwWj/vj9wStQ0/wVwGLR5y+8RLTam7B8Ff/Li82JJNpdxN3L3V6Bkhwxje7sA+bu95dkSnYhlp/cFm5Y+KgYLkWK5J+hapQfrg5Ywp3IJWVdWjL/v0H5iaKeH92SlteorQ6mQAV1nCwx9u+ppT8DfZt+2IXM4FVXd264kZGtfyklLv8Wl4Td1EvxxZTpQMy22MkzkiW4myol7Qdqi3atx53LUbjUnfMyuyC2bTZT+vfJmWczeOTkpvj7XDKPndyo1EfouUnBgLvqHsSC/Q8NvO35mI5x5Iz+EgezO3htHX9LTkkzvleRBT5ZgC0WnAxYEes3SXCdf4o/7FCjq7Ata7pDQgGZpBkW/C+pJomy+2TfMC5bg5gTgNpg31WOzvPwZvO/ssYpII7fc6AR7c3KL3VOO5yn3sd
 eZnOy1MC
 SJfwjo3gUeFsPPZQz8EHKnbrgsr6F+Y83WmqPp45CVmpAz5+iBuqYUCgefz5ujMJcS39/8YA8lK29geJvOkoNzyMRqFQcKE1keVYe0/P10/DQw410PM3gGxdvU8pDR5CdR/3GbnISpS4eaY08k20jr5MlZ49VEEEzkE4zesb5Gmyz4r2urEUcHLtOyB/OFBMcH3qzVjUVDd3U8a0TlmYHufnmsRUtSvlsiDYNGBcz5zoIvG9/4eaCo3iTNcPRqxhCHZ9QKqZXUGNtR61bKWJF9j2R5aPLfTN2D8/Zq9lYWWUWcqAHORmc0oMHJxDPyeJC0Pbkafm2rAuKPlix3HDTnXlCCwg1MT18nfZHvntoZvGvPUTjit6kbPp2qinRpWWkM9iPiP5dPaLl3VupdFR49xK0cI6WfQB4sT1PeWHqnJ0B+soT798Jjk2qlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

parse_node() looks the node up with of_find_node_by_phandle(), which
returns it with a reference, and do_add_property(),
do_remove_property() and do_update_property() never put that
reference. Every property command written to /proc/powerpc/ofdt leaks
one. Put it when the command is done.

Fixes: 610d91511f99 ("[PATCH] powerpc: Add support for changing properties from userspace")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/reconfig.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 18e3f1a036e3..5a0c9c0b6253 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -271,8 +271,8 @@ static char *parse_node(char *buf, size_t bufsize, struct device_node **npp)
 
 static int do_add_property(char *buf, size_t bufsize)
 {
+	struct device_node *np __free(device_node) = NULL;
 	struct property *prop = NULL;
-	struct device_node *np;
 	unsigned char *value;
 	char *name, *end;
 	int length;
@@ -296,7 +296,7 @@ static int do_add_property(char *buf, size_t bufsize)
 
 static int do_remove_property(char *buf, size_t bufsize)
 {
-	struct device_node *np;
+	struct device_node *np __free(device_node) = NULL;
 	char *tmp;
 	buf = parse_node(buf, bufsize, &np);
 
@@ -315,7 +315,7 @@ static int do_remove_property(char *buf, size_t bufsize)
 
 static int do_update_property(char *buf, size_t bufsize)
 {
-	struct device_node *np;
+	struct device_node *np __free(device_node) = NULL;
 	unsigned char *value;
 	char *name, *end, *next_prop;
 	int length;

-- 
2.53.0


