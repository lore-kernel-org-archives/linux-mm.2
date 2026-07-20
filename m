Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4056C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6826B00CB; Mon, 20 Jul 2026 05:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E3F6B00CD; Mon, 20 Jul 2026 05:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DF76B00CE; Mon, 20 Jul 2026 05:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB286B00CB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03851807D7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:23 +0000 (UTC)
X-FDA: 85008644448.28.677804B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 52DB120009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nuV1+Oma;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoAN0y6FBHdhYz5mnXN2m/MenuFvaBCTttN3p/SNEU8=;
	b=ZuEYIeWcHEGT+mLt7nPt+cisJKW+Kvo2GWyOjgjxTH3h2gdd4eXS4Ll2yFHjaicziQCDHd
	oV1PUOnfxzTL3UdSUby2jdbXtX/NktfZeaBctMnIe27OH+/47QpmiSd1YjvMUsZTv7ot3P
	FQpHjhudVsLzN3aJWDGYAsE7LdY3YQI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nuV1+Oma;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540062;
	b=4o4q/9ZlQpjeSj1fvs1pv1URsbZwaZpv7EHfIQbDqjqFFF3p7P4VfAjI09oQ3z45P7b0VE
	suYA9j0pO2SL8z4j+kE2ED08anDaYixWKcVg3FPL+R0NaxgOhsxqlU3KWXueFrehJxXAXz
	P77Lgg5g2p7IzB0iK+44l0h1Isim5LA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E026460A79;
	Mon, 20 Jul 2026 09:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84281F00A3F;
	Mon, 20 Jul 2026 09:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540061;
	bh=AoAN0y6FBHdhYz5mnXN2m/MenuFvaBCTttN3p/SNEU8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nuV1+OmaDbtEE/kpSxVOmzaONIL4JzbAvSzY05OdMIMfnHz+AMqh6mjFlPOsJJXs0
	 6bozl+rb0H/Httt4MayhClDm65xHlUsRM3kUXid3E8vzWbUh6dK3Y8iMClD8cKw84f
	 fRhPSA4Q/vAyw5oyV51YUiouhkpi+RjQH2/6wterf8hvPt9mcPp9GOlYQFD5xrq//i
	 IICsbMeJnPGZXafX6jdU+Ppab/SQ5Wqlv1rdnKZRzmexXOTRNg5d9gvxBkHzPwW7sM
	 mCJV28eaVM1+AjqqrcTyJKu53GAM8ne6KlZZkgX0bPXmhoRrN0y4RzEltWI/1cGd+u
	 9RSHe3ic/VQlg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:30 +0200
Subject: [PATCH 07/21] exec: release the replaced file with
 do_close_execat()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-7-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1262; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2ognuNn86edeBu6t/u9qeT9TK9VxXPcwlqVi+uJovvk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm6yk95+L0+Z49/6X8GM+3szX3Hy3uFhM7p/oGdf9
 O97onVGHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMpn8rwTyP1k5HXEXvH1brH
 5yk8ZL/WFT7tLtMm3vWNSk15q37JujAyrG9Y/uYS02ut5lau62Lf2187Xs/Y/rrVJ9nZpjy46GY
 mDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ybxxog7dw8hugstyaotnp871y9i4peg7
X-Rspamd-Queue-Id: 52DB120009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784540062-979288
X-HE-Meta: U2FsdGVkX19uYggJxuNQvHGkapDEiqR2qDvl+5uludoRJWRu9hF/LxqLLMSKRJKwqjoG5QaqMGzgIIMt4TfbWnVwbyiwrZzpcq3Z9SeUPa2cmXCI35XkBeiVOkWfISG/yz5jqnfxyTPOmD2CdX3JuTLySjAnlh+fq5oLwkT11jx7qlROjy6lgAcgULx9LWIPEXti//4apeQyo1BVmCEHvDh9ya5Qgjvo+CVVbKhYaUjS3rDPHTSd+QmbsBTHo+K+fnyVk5CaolrjxZsZ4N72B34lIcAptdMQ0F6XJzHT40HwyHD2U/4Vq8aMGFjjqTmzMxEhmRDz+EysjlprnF/j1I4wyCX+kw5fkUqbsM1S+U8eGp+u0GZTJ0qM1yiingj2EvMIdmuNKsT8omI8bMAeYV3hCWzmPcuAYzsXYCwdAtjvQ/7Ksd5V1gItNDmjYjb7ofb8RWCTlCz9ga4MMhMzngJ1KDA87q9arDoi4A3cDxWeVYRB9s6U+44HV2105V+mKT/lCDihmxkfsF8Bu+hbslHIwePzuf7TaMzhkLlhTyKPPeqN6tE75ZPkjI630/hKsvd2CKrxoVxaZeQf6HBbR6ShVgV4iG71UJPuNcdg30KhRKDtL3Wh1N+cB5PG3m8VB9PJDDLbcYFZDHz3+2oxgNX7t90Gw86GxHZNxCWa1GLI3j1L6jGbmSKtbe4pDQFV+xIovmSnWOLr6w7r3mepDmg57DqlsRrCd7bmbAq9cB3wveTX9hmKwP2ze1qUHxfqXsUuAMXeexcoz0AE7/Jp6mbnQSkCrnarjkfCAuUHuTS6nbRiB54v4gxTmiyOBnjKCZXiApCkryle5ATzme2qJMBLFBYNjQIdefFBTGNaBtZGylOnELNOoV781hUf4KeiNiw7X7BTGCBuiG2Ohfq7KL47rFkaPQLqANk+9TV18NWsncLFak7c0Rh9zj5chOP8MmLBvfXdd2sMsz4femF
 T+q5BVZ8
 I2aQpCVqUfq2tBpJUIbdwN6ftaxvCpVXtW5bAydqYx15dlPRc7GU9dK0L5lGeh/d0N1vug0HIZ93DYSnbI5cNn1DYWz4wXfw4hCLqlbXEUKl58z9xAZ3o3igneEb6u6GK52/QhwdZindmWKDBpI07BztiWEWa9s2fUmnmO5kQcNfHUy91PWAXqhuU9jEB3VpZ7+WJ5xmfeiNWE6nhYWtxn5KMRUyp/FqlyD5/ZLieMkhjj+RZ5J4TaGCFJ1Ff+cv+cr6UXRk54+BjeASXVphBH9CHvRH5LmrRH+OzAnzZlTyqSTVd6vj9Pn/IoimyRN9Xqy5Bdnkyn+ugoEQ0R62V692qzz24wvaaJYSKi97eNUOP18c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the format search stages an interpreter exec_binprm() swaps it
in and releases the file it replaces. Dropping the write denial the
open took is done manually ahead of both release paths. The one path
that keeps the file silently relies on it not being called.

Let's just use do_close_execat() on the two paths that release the file
and drop the denial explicitly on the one that does not.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2f50aa039827..6e540f4b43d8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1741,15 +1741,17 @@ static int exec_binprm(struct linux_binprm *bprm)
 		bprm->file = bprm->interpreter;
 		bprm->interpreter = NULL;
 
-		exe_file_allow_write_access(exec);
 		if (unlikely(bprm->have_execfd)) {
 			if (bprm->executable) {
-				fput(exec);
+				do_close_execat(exec);
 				return -ENOEXEC;
 			}
+			/* Only the reference is kept, for AT_EXECFD. */
+			exe_file_allow_write_access(exec);
 			bprm->executable = exec;
-		} else
-			fput(exec);
+		} else {
+			do_close_execat(exec);
+		}
 	}
 
 	audit_bprm(bprm);

-- 
2.53.0


