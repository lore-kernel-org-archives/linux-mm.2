Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17369CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3371D6B00B0; Thu, 28 May 2026 05:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F496B00B2; Thu, 28 May 2026 05:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C316B00B3; Thu, 28 May 2026 05:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15CA26B00B0
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:57:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5EA716193B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:57:45 +0000 (UTC)
X-FDA: 84816376890.06.18E8096
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0F0BF4000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:57:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=O3C9UCiZ;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf27.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEVp4I6koulmeQRg+AIvYnO6/dhMP9EJtXGNcBGqGsg=;
	b=r1QB9OyRQ8VBsq0BHW5jHhIKESk4FpXmwf/V9ovs1Vnn8A7hmS359NhjnoMOPh4hheoVdy
	zFm4ZLOylTkoqLGm9tS7muzdSHO5WC6XmJHilX76q9JuWDQibbAOMmYu/8Kycmb2d3Wsr3
	i6/ANdM9/P/fgykYLF5ddo9LjZpesOw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=O3C9UCiZ;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf27.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962264; a=rsa-sha256;
	cv=pass;
	b=E7aTT6y4t4GaXsXeABmtezW3lZ0nY67ZitXGISc+fDd53MDSFYAq4pW/U9kHoLkgGucFWl
	ViFTtz4KIvGV7XH9CZh0MPUYNqSNDcvUByREeKYAxqTV73/+THNl39XgwVI+i0SvFDv+oF
	Uz/KFxwEbPncp4Qg8fudwZMV53h4R1I=
ARC-Seal: i=1; a=rsa-sha256; t=1779962061; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZSD0dV6lu2Vs+GZU/uLmqBVKLcZQTGeGjy2Gjh6UBP4213jrrG+4btwTtJgRBcLfDVNWnhfpATXTDqCtCqF0rKfy6gp+ZLTdaIrKrlSPzsYPh1HbbI1LZSJzSTLDLL5MGTqbyQQafwD93JyAq1SKIsIPDkivvJ5Bblsdq5bnJoc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962061; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WEVp4I6koulmeQRg+AIvYnO6/dhMP9EJtXGNcBGqGsg=; 
	b=FNBcgu95moxMmh04dwtDpU3B829r1xYZ9iRBsf/YE6S4c4QtVhaVzAMDUlUX4MWCoroEvqNGPXjXHfsio9lyXB4WiERWwyU2li6Uulk7E3TTLnhNi4S9eeHahOa+4KtIrWHk8aj4Hp4pUI8Mac3K85dj2rnbcMePE5zV/cT06mk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962061;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=WEVp4I6koulmeQRg+AIvYnO6/dhMP9EJtXGNcBGqGsg=;
	b=O3C9UCiZqPS7hLT7Zuq6qgdvMasGpu8vLibnOglnjFiWu1gjTzYAPeAftjYYrShv
	6MpmBwRW6piWgJpWqTBAdKclQQ4VVK8DZFPDtnzMhg8BCSBfKuNyRkGcj26edyh+O7V
	Rplpyc9maRQnBeYk571pu4AG/nEK3MuPZtKRUFBo=
Received: by mx.zohomail.com with SMTPS id 1779962058247658.000025721033;
	Thu, 28 May 2026 02:54:18 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 10/13] exec: require absolute paths for path-created templates
Date: Thu, 28 May 2026 17:52:31 +0800
Message-ID: <20260528095235.2491226-11-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: wmzuk93f9ibgjukjyk7kt4t1nsw4wuau
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F0BF4000A
X-Rspam-User: 
X-HE-Tag: 1779962263-711867
X-HE-Meta: U2FsdGVkX18+xXSXIrCxQTFt3esUPr150HYlXZYxeI8LvKtLEUgdymtdf0J5alA3gj3DygjOiU7SNmEn8TpQyl21wPFzyuLUYYitpKzSIj5VVZPGzntXjed2VKdK2JHD9Y1J2o4Hn3h9xOvrq3P59Asit2jOgaZCTRDorC7qIIfx94BUusA9ir/5ysPwQFEBKVC4KU5PHJKQEoYpPf3RvRdiWDSDyKZGy4Rrxrc2YOZjRQaGJoS3Mym257Gg6rO6U/PxOejKmisT2FTLjFQKqNiIJ5LGePepXLBE7bw1p9WgHQiWrQeemxX6nZMmySSxiYp+GkLmjREwmGXynfvJmmS2oLOeYzB3k+wi3sZ/yApLeXm/keFwJN62/QJLz3q/ns407NmIG3r8KZWOEXuExvl7buvYtPUnge2xaatq6StEp1T6YeQWoLXdN4AZg/aXJLMStmPVnGpyNmFZBoAphud7gdlVLpk64SFu+0ULOGXEajuT7SbLnta4ZRilv0/TM/YBoHBGKPJwNrPXDzx4vtemXhFPSFtPpojpyMsnu5EFvcbOPW/tzWWT1jvfCGcs5pNNlLG4Y0DsJMM7g260p+c2+mNax500VD+EEx4h8SIIHmfixTveTmonE/kYMMmsahg/vcbAUJ8CV20VNYPTSXZUphniaS+Q7bBmjP3eF72iJ8SQiFOxXoczZy+bzHLJCgp+vuivQXkcaX6A9XaEBGlbxYXPSAz6Wh1LbDf5n6+sAmHNSakrTAvZCTrT9vl/4S96vJFiJ6jTJYU0OJvDfC8bAIJwvLiTvpSgLiL0QKBdV7NL750wGUzG+P+Su85L9vZh+kVDcYQ1cD5euYfjYvjkYDjLaAkyCGCIWb+4jdCmTN5KIPkXWy3r54vIYABEY/bwzdhUcIuJpICZoeNiBsyGgCSMmfKAmL+lzf7rUk9cGu3GiPH7E/T47UqnwE5eqiasIyUhrmeDdJh1eM2
 pXRDkkSp
 rMoHa/IpRzbOriUAdvfbdXQ+6d4lHG3KDzaFxCSmBFPGvNy+VhAmF5MOq+SKH0evb7/7roFNRrHzGlSxtaadLLZZCpgNgpudsmB0DDiwqhw1uGNIMfqvc+0rTJdfqeKP3vCDGSQg+1qGVsOIeadj2hiRhZfRiBN+Q5KVW3OPtuaS9MGbJervx5UXFyWYfpkOoOf/GFCGDjKj9ilHtX1HQGd4nHl5JZyNTOIJjnfo+WiHhw4ueRHBks+/Ug97kn1a5htAVGd+b8WStR32rPEvIiE+UoLrTss2UvcsI1cIgmzRagxwyHN5sZPHj57xdoIuNHN4eO7LZKxIIcTc6Xohe/sgtDF52yFzOCAn4VZhlMYF75Hwj3hu+ubgUCBxqf4LV4Fnw8hahXL5wrhlb+w9oi61VkqdvdzOmrVl9irTsYzzD4rA4nybVIcrxkgAB1KDBvYdz0OJ/l41+NRj+CHyqVVwhaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Path-created spawn templates re-open the stored path during spawn-time
revalidation. A relative path would be interpreted against the caller cwd
at spawn time, not necessarily the cwd used when the template was created.

Reject relative paths for now. Userspace can resolve the executable first
or create the template from an executable fd when it needs cwd-relative
lookup.

Signed-off-by: Li Chen <me@linux.beauty>
---
 Documentation/userspace-api/spawn_template.rst | 17 ++++++++++++++---
 fs/spawn_template.c                            |  2 ++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/Documentation/userspace-api/spawn_template.rst b/Documentation/userspace-api/spawn_template.rst
index 0396d292fd17d..afe215e51db6f 100644
--- a/Documentation/userspace-api/spawn_template.rst
+++ b/Documentation/userspace-api/spawn_template.rst
@@ -30,9 +30,20 @@ returns a template fd.  The fd is an ordinary file descriptor backed by an
 anonymous inode.  Closing the fd releases the template.
 
 Userspace can identify the executable either by an existing executable fd or by
-path.  Exactly one of ``execfd`` and ``filename`` must be supplied.  Passing
-``SPAWN_TEMPLATE_CREATE_CLOEXEC`` sets ``O_CLOEXEC`` on the returned template
-fd.
+an absolute path.  Exactly one of ``execfd`` and ``filename`` must be supplied.
+Passing ``SPAWN_TEMPLATE_CREATE_CLOEXEC`` sets ``O_CLOEXEC`` on the returned
+template fd.
+
+Relative paths are rejected for path-created templates.  The kernel stores the
+filename and re-opens it at spawn time to check that the path still names the
+same executable.  A relative filename would be resolved against the caller's
+current working directory at spawn time, not the directory that was current
+when the template was created.  For example, a template created for ``bin/tool``
+while the caller is in ``/repo-a`` could later be spawned after the caller has
+changed to ``/repo-b``.  Revalidating ``bin/tool`` would then look under
+``/repo-b`` and give different semantics from the executable that was
+originally templated.  Userspace that wants directory-relative lookup should
+open the executable itself and create the template from ``execfd``.
 
 Creating a template for an unsupported executable format fails.  For this RFC
 that means non-ELF executables fail template creation rather than becoming a
diff --git a/fs/spawn_template.c b/fs/spawn_template.c
index a11a7ed676416..6430a6645fb57 100644
--- a/fs/spawn_template.c
+++ b/fs/spawn_template.c
@@ -441,6 +441,8 @@ static int spawn_template_open_filename(u64 filename, struct file **file,
 	tmp = strndup_user(u64_to_user_ptr(filename), PATH_MAX);
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
+	if (tmp[0] != '/')
+		return -EINVAL;
 	kfilename = tmp;
 
 	tmp_file = open_exec(kfilename);
-- 
2.52.0


