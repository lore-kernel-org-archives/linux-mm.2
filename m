Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D14F6072643
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZmY/n0G
Received: by kanga.kvack.org (Postfix)
	id 730E46B05DD; Wed,  4 Nov 2026 14:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707386B05DE; Wed,  4 Nov 2026 14:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6BC6B05DF; Wed,  4 Nov 2026 14:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF046B05DD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:26:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C35BE80852
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:26:33 +0000 (UTC)
X-FDA: 85398418266.18.A3F790A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 18ECB20008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:26:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OZmY/n0G";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzL9ZYHhLfhD3DOSumSkk0Gb2fITAVoHxCDSq8u5ZOY=;
	b=yZFB/Q+dhhJMsvHGx1jGdrq0liVx6yA5iLoU5ol/3cbePE/x9sKTmQZtcDEBSZbaJRUktr
	U7G6LrvyBmvMQMxhVBGrZCyQ+aBa6Lfu11/BAGzSabNeLJ2B8ByGWnyca8VDxRYJtZdME5
	QrFtdKmeeUqS0dXcVyiaDvZauP0n+lk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OZmY/n0G";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820392;
	b=XlRtDN262yZJXDJpk3nCsFc85rViSFgAJMtA3M1eUXgm4rHO6ZyXeTbkvEqVEBrGb7eMbg
	YjPeWQN+LuTfVla1teSLdMhfxJC155JC1u5M1AMQNPSG9aLRTZA8F7BgejXPRg4QJQacu+
	mb9T1BtZiBi2cN5qNJYXDc2tZsPDVwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A876A60A8A;
	Wed,  4 Nov 2026 19:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A02B1F00A18;
	Wed,  4 Nov 2026 19:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820391;
	bh=KzL9ZYHhLfhD3DOSumSkk0Gb2fITAVoHxCDSq8u5ZOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZmY/n0GXXd/waY5eO8CY5Onurst3JuvNiiWNIXcNO2ZuOFKp902BomvRAZeqhqov
	 gVBa7tGTm8eGOA6FIqPzs+gKGb0cET9WaFFoJDGhKN+qiibaBT/bgrlsrKWepwCufy
	 7xbZtg/lGvVf2Z6lEc3/gKQcCopkPYa2/MYuxGe78rFjMFuwi6sASyH6Jok98Wg17F
	 cJ/qQVE/skC9zQGR9GKwMIm//f3mEfB8/4bBi4VeRM6Lw8lfYzjOtO7fBSGQY1KnwG
	 yl+O33qpdvuGjSLboBidD8ILci0GW1gs7UGQ/cvvcbiCIna8PYu+uszQ30CIehYMR+
	 tDP/eU01ohS5g==
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
Subject: [PATCH RESEND v2 42/51] powerpc/pseries: bound the lengths in the ofdt property parser
Date: Wed,  4 Nov 2026 20:26:17 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-42-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4036; i=brauner@kernel.org; h=from:subject:message-id; bh=1x5L5ygLqoH4QYrbzxN55G88uXTL5wNw5UNSw5/l5lQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvx/eMaUE0I+8x7uP2vLHsplqPp8Uf8cnbKLyd/ve zkpum1k6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIciOGfwpWqRcLVdK6Yk+U 7Mjin33JpmbO+9ppHJaBzs+t3kx9ZcXwV37rzQebpE0czPNr1/Zo75BRluja0J3FW2zd03c/onQ XAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cwkmysf8ewcqrf6bzm56qm6gnpch1uo1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 18ECB20008
X-HE-Tag: 1793820391-571515
X-HE-Meta: U2FsdGVkX1+/30vKy5/BU40/SBrmUnNncrOQ6ChU1aJqhs+SNOUMJwuz81/CPb8YmoAlC5unJXdOA0iisvk6BUhk7a/J9PTcI7bThvWp8+PM7P04xHw8FBjyT365HlkYkNfQsQpGDQ0d2x3mqskDspJf++MC1eUCRdFlJXDV/xhIPTiSQ7mS1CeFjUhvBSUjrm90YQjZhvzOYg12GM7RJ1/+Lex5pcsfgFm1A4Kl4N5XrTlAvif7qW+j5+pXEWzOVIa6xa5elsR6VBykkc/dCSdGPs64XvK5GmmFwhdnlHFJHfeGfAILRRtCMlzbHq+Z1RDhF2XLhWwjSQNu8PFa0UW3gKuxlvBZuxTI/7qV+sjM37tNdt65a8A08j/kuLTKJzSscc4vXMihM7es+lKxJJOtDuqehcj9q6KakIPkoE6b0z/MJ+P0VdWRIb5cxPz+E9Q1ND27KF0IBgl2e0N91RG950RvOSuPskCNCYWQ3Aea6s0o3khWj/G9UO5xIZz1SQSGf/R1k6UOc7fpl2aJWQmLcTQu5goqx7AX4is5pv7N6hqTFspiAowzUoLosvIcojXjqrwQwxB3Z00XaNBfHo77A4xwWkoFc35iSsJTRiRfdLVdnNrEwDhzEyyvQyZ9yIqostLzsJdXP69XsSYyvqmnSE1DuE5Xil7AaLcOLLUcDlL5mnCoRtI6QqzWZY54goTnUYVQu+moNVTp7MMcWH5JhNBtF/tsTbDFDHpUG5Uz1pwraf0LszIrqfvz6icnWA6N4E1yXEu5kFXKOoLXwtmuwc4QTzV8AocBEolHLPqKTrVd3f7O/9BN+QZcVVamsl0ODjwLLSZ2aLBW/ZroqqlwXaQVdFTRChqv9ivZqMkH3r9Umf7+MabKREiRJGUvj70SdR1PAmMCIbooKRmyjK9Z8Vt1d0M8MFM8IA1yt6mZVRH/tziyAT0WG2Mo87NJIhBmFrtPVBr2sxCAilL
 hcU3Vi6u
 jJPZHtP+jVW6imj+q4tds2v8uaUwkmeTvVbU2UBHOyr4IcsY3yB6j5zz8rjnu99Ccu7fr88MfhIa0Fz5lme1iBK/4SseM+GMq8GUcTRPavfCYyWE2ext3TC81lCks5bm7rIOtxvTEsluGju7GUbHspcqrydCaKsNsUdt38lwZggqErRMX1lBANuxsrCuIr1h0v0mZR2z7/FQvHAhg8cpoor2QsTVySRpCVshiQ5TN5z8sbVbi1gbC+SUmccoSermBsxFdEHcg4LgKsEqBnJIMOCl42WRoZMQOBk0Jlfvw4JLsNmUxFVaqOggdCvuzZxISXnDupOrB8CX7VAKlPmF2N4m7i4JmlfjyufcMWdZIQKG0Gzbo4JyGULAlSHxoB4SpFPD/o2xRBkEjQOVQIVjS0QvR4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The commands for /proc/powerpc/ofdt that carry properties, "add_node",
"add_property" and "update_property", can make the parser read past the
buffer they were copied into:

(1) do_update_property() computes the end of the buffer after
    parse_node() moved buf past the phandle. So the end is off by the
    length of the phandle string, which can be padded with zeroes, and
    parse_next_property() accepts a value that reaches that far past
    the command. new_property() then copies those bytes into the
    property, which everyone can read in /proc/device-tree.

(2) parse_next_property() parses the length with simple_strtoul() into
    an int and only rejects -1. A length above INT_MAX turns negative,
    tmp += *length moves backwards and passes the check against the
    end, so *tmp is read up to 2G in front of the buffer.

(3) Updating "slb-size" or "ibm,slb-size" reads an int from the value
    whatever its length.

Compute the end before parsing the phandle, reject lengths that don't
fit into an int or into what is left of the buffer, and only take the
slb size from a value that holds one. The file is root-only and
refused under lockdown but the parser still shouldn't read past its
input.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 610d91511f99 ("[PATCH] powerpc: Add support for changing properties from userspace")
Fixes: 46db2f86a3b2 ("powerpc/pseries: Fix to handle slb resize across migration")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/pseries/reconfig.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 5a0c9c0b6253..b543afbc1efb 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -114,6 +114,7 @@ static void release_prop_list(const struct property *prop)
 static char * parse_next_property(char *buf, char *end, char **name, int *length,
 				  unsigned char **value)
 {
+	unsigned long len;
 	char *tmp;
 
 	*name = buf;
@@ -133,13 +134,13 @@ static char * parse_next_property(char *buf, char *end, char **name, int *length
 	}
 
 	/* now we're on the length */
-	*length = -1;
-	*length = simple_strtoul(tmp, &tmp, 10);
-	if (*length == -1) {
+	len = simple_strtoul(tmp, &tmp, 10);
+	if (len > INT_MAX) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
 		return NULL;
 	}
+	*length = len;
 	if (*tmp != ' ' || ++tmp >= end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
@@ -148,13 +149,13 @@ static char * parse_next_property(char *buf, char *end, char **name, int *length
 
 	/* now we're on the value */
 	*value = tmp;
-	tmp += *length;
-	if (tmp > end) {
+	if (len > end - tmp) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
 		return NULL;
 	}
-	else if (tmp < end && *tmp != ' ' && *tmp != '\0') {
+	tmp += len;
+	if (tmp < end && *tmp != ' ' && *tmp != '\0') {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
 		       __func__, __LINE__);
 		return NULL;
@@ -320,8 +321,8 @@ static int do_update_property(char *buf, size_t bufsize)
 	char *name, *end, *next_prop;
 	int length;
 	struct property *newprop;
-	buf = parse_node(buf, bufsize, &np);
 	end = buf + bufsize;
+	buf = parse_node(buf, bufsize, &np);
 
 	if (!np)
 		return -ENODEV;
@@ -337,7 +338,8 @@ static int do_update_property(char *buf, size_t bufsize)
 	if (!newprop)
 		return -ENOMEM;
 
-	if (!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size"))
+	if ((!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size")) &&
+	    length >= (int)sizeof(int))
 		slb_set_size(*(int *)value);
 
 	return of_update_property(np, newprop);

-- 
2.53.0


