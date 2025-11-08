Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338A8CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 19:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B398E000C; Sat,  8 Nov 2025 14:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BE68E0003; Sat,  8 Nov 2025 14:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348778E000C; Sat,  8 Nov 2025 14:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CBB98E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 14:09:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4CB413BC86
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 19:09:58 +0000 (UTC)
X-FDA: 84088379676.18.8689E95
Received: from mail-10624.protonmail.ch (mail-10624.protonmail.ch [79.135.106.24])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F124120010
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 19:09:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=yhndnzj.com header.s=protonmail header.b="fEfR45/B";
	spf=pass (imf29.hostedemail.com: domain of me@yhndnzj.com designates 79.135.106.24 as permitted sender) smtp.mailfrom=me@yhndnzj.com;
	dmarc=pass (policy=quarantine) header.from=yhndnzj.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762628997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WfmfezCASpoeRxzyP97/Bg6TuZeskJUKe+Q4rAekhjg=;
	b=ItF89Rl6JGX4hcZ/7bvA7InaRA0NqYdwORT7/LbIVtw4VAB9rVElHLyni8YbEHxH/DfvSa
	Ue+B6sldQWtn/F2EJa87TQAuG7kPkoQS8M+X33kKdtwqhZb4XHVSBwcoHOsnePEPTJZ3jE
	oXgQfyfBUSL/iSNTYoVaHnv1XBGFmKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762628997; a=rsa-sha256;
	cv=none;
	b=jfq0VmNq9YOrpq1cODvLeR9VPlsThS8zG/Er/1WZ79j2HMErpgOw8Mn7LciR8XnKfQz1H6
	x9NdKugKZDz1r2GU8e2mZjAQfYEwPxjw0oLexC1UVguf1P6BCpSDkTkIZ3ElS1DwGA5sS3
	Tvyp7t/bt8gh/LQPha9hMTzreOG3Tic=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=yhndnzj.com header.s=protonmail header.b="fEfR45/B";
	spf=pass (imf29.hostedemail.com: domain of me@yhndnzj.com designates 79.135.106.24 as permitted sender) smtp.mailfrom=me@yhndnzj.com;
	dmarc=pass (policy=quarantine) header.from=yhndnzj.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yhndnzj.com;
	s=protonmail; t=1762628992; x=1762888192;
	bh=WfmfezCASpoeRxzyP97/Bg6TuZeskJUKe+Q4rAekhjg=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=fEfR45/BGmwWjUPZt6R1yF9uOirxoDV5bmKbJHcdmYTVN6KC1lLXBcFooWKTSwOa9
	 EvBA3LO5ooz9thOjCxycCoPWu7v7B4iN0NMZ5RJR+xqfPiQT9A+bflUjd8jKs5vutw
	 o8WpXvXUEpgUiQzmG1tsgj+BWtJGrbSKTJN0Z8N3f62gfnVu0INV3RaSOA1XG4ZrVJ
	 ipi2kFQQZkEomm03BbX3b++TPECxdbtcQm2y7BNFPnOCPktyGZIlGIleeRnW+vqzZo
	 1V/UZT605WmGMutL6ZSZpGrRMS+G1bxZiN+wPuGJ+p/VQfm5U6jiU6lxb/ogidYUvn
	 dLse2aUSQu/5Q==
Date: Sat, 08 Nov 2025 19:09:47 +0000
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
From: Mike Yuan <me@yhndnzj.com>
Cc: Mike Yuan <me@yhndnzj.com>, linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, stable@vger.kernel.org
Subject: [PATCH] shmem: fix tmpfs reconfiguration (remount) when noswap is set
Message-ID: <20251108190930.440685-1-me@yhndnzj.com>
Feedback-ID: 102487535:user:proton
X-Pm-Message-ID: 149e0ed8edb97c432bef16be68b2175ea0fe5f86
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7thrik7fupr5o8ngksxc4ojdjqqo9f8i
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F124120010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762628995-654739
X-HE-Meta: U2FsdGVkX1+fYQsiAiHted2jsbFPmsuq2Xj7hEQP4Z8TIR7HulPXQHD4Ubt6uFNECTwF++bJK6Xy/qnSi1A/HBaHDStyaHkrzYfk+EBPFz6OYVjnA0o8JlT0JB6H+fNMCIgu6TXH8fq1vDh9WLUAqpv/ZB/4d77FYts3mfw64P3TjcIuMq1NdYl2r1yGCAcchvh0Q4aXMRfFB9YbiEgDWhjPvyrwN8FqfKbtH+NuOUB+3NukN1e0PhGETfooydUcscxzemIuE/QU/XGwb301Kt7GTZMhHbIGTuwp0lmLZcuMV0J/hglbeor8c9T7FC1QrbFGbvB8LHBBfLR2KV6nnwU2LQh/qbPhyeN8qT4Arhec5WQeHyqZyenPgPA5u10/KJDLxs3QFUv0VU2NZ5GV5YMsW6wTAK60y/PaHUcvrbZ5n7zqXtt43vufHJuyy9AbwXw4kFdmjpph4XhwfuMR9y4ElMyZhyRRe5M67/xtll3L9bqVM846vWIOTXZNCf+EPHf4YtKWe6k2E9WlYo9JTc11CkXKJqJCI1RlWEmVE/tuhZVoulCblI4JiOlK1TvQI5KXwR2UrV4Ouyk/7rznEp4842fUEfLMGuk2hMzE2ankmULvU9/IHr6yHDhcu3udTRhr4ec1YrpSJdmYpsCFqGAzE8SEhu0HsrRV/ig/91GAsudcqEuwSmaKi1icObOt/gLKIgewfssAF+TnOt1pIqjXQ4um7whYkAySlLagMzztPSkLXHIUaHzirXqXd8FjvkhNHTVKu9GxBBnjzb1c+tN3s86hpiuoBjeOMEBdfkQy3VlGB3XSyzGMeLGZh9heSASwF0pWT13xfKs0r9bHNpQDARz7yf/heuuEbkIV30rj3MZqcKa8U6qSEH2N6XCzgc+4jRn02tTMbeZMxExn0/4Cn2VB+rlM0kICTkP78IIWiKc6kAWMAFJ1HgAX/rcZUwmZNsCsWU0/SaXGnWp
 lTy/mGBH
 vVp2vW5H97kn84SWzczA3ZLYTq7OIPAudBNTXqdpgyO8bjOOYODOmjz3zxPxTPHtWZyiI/E53buv8ZPP+gcKgSoxtsZorMrEb0+doGF+fcTBaLZ15iHJzgj+U701BObxPb+2WE+ywYsCbhlyHjILwUOnkK30e6ZolHYlEQ4Age/msH8lcD2gv/A0jjvTFIO2JrmhKF8LNILKxLrNXVmI0VD1KY7TenmgNHdbb3FIvlld3kLcUlOrtekGEUyW5D1YlEEGxqPrDMfeXyntEp8L/NvwkoAD6Ypeew8Zl4Ad2o4ANgEqVXarpr/BTig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In systemd we're trying to switch the internal credentials setup logic
to new mount API [1], and I noticed fsconfig(FSCONFIG_CMD_RECONFIGURE)
consistently fails on tmpfs with noswap option. This can be trivially
reproduced with the following:

```
int fs_fd =3D fsopen("tmpfs", 0);
fsconfig(fs_fd, FSCONFIG_SET_FLAG, "noswap", NULL, 0);
fsconfig(fs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
fsmount(fs_fd, 0, 0);
fsconfig(fs_fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);  <------ EINVAL
```

After some digging the culprit is shmem_reconfigure() rejecting
!(ctx->seen & SHMEM_SEEN_NOSWAP) && sbinfo->noswap, which is bogus
as ctx->seen serves as a mask for whether certain options are touched
at all. On top of that, noswap option doesn't use fsparam_flag_no,
hence it's not really possible to "reenable" swap to begin with.
Drop the check and redundant SHMEM_SEEN_NOSWAP flag.

[1] https://github.com/systemd/systemd/pull/39637

Fixes: 2c6efe9cf2d7 ("shmem: add support to ignore swap")
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/shmem.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b9081b817d28..1b976414d6fa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -131,8 +131,7 @@ struct shmem_options {
 #define SHMEM_SEEN_INODES 2
 #define SHMEM_SEEN_HUGE 4
 #define SHMEM_SEEN_INUMS 8
-#define SHMEM_SEEN_NOSWAP 16
-#define SHMEM_SEEN_QUOTA 32
+#define SHMEM_SEEN_QUOTA 16
 };
=20
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -4677,7 +4676,6 @@ static int shmem_parse_one(struct fs_context *fc, str=
uct fs_parameter *param)
 =09=09=09=09       "Turning off swap in unprivileged tmpfs mounts unsuppor=
ted");
 =09=09}
 =09=09ctx->noswap =3D true;
-=09=09ctx->seen |=3D SHMEM_SEEN_NOSWAP;
 =09=09break;
 =09case Opt_quota:
 =09=09if (fc->user_ns !=3D &init_user_ns)
@@ -4827,14 +4825,15 @@ static int shmem_reconfigure(struct fs_context *fc)
 =09=09err =3D "Current inum too high to switch to 32-bit inums";
 =09=09goto out;
 =09}
-=09if ((ctx->seen & SHMEM_SEEN_NOSWAP) && ctx->noswap && !sbinfo->noswap) =
{
+
+=09/*
+=09 * "noswap" doesn't use fsparam_flag_no, i.e. there's no "swap"
+=09 * counterpart for (re-)enabling swap.
+=09 */
+=09if (ctx->noswap && !sbinfo->noswap) {
 =09=09err =3D "Cannot disable swap on remount";
 =09=09goto out;
 =09}
-=09if (!(ctx->seen & SHMEM_SEEN_NOSWAP) && !ctx->noswap && sbinfo->noswap)=
 {
-=09=09err =3D "Cannot enable swap on remount if it was disabled on first m=
ount";
-=09=09goto out;
-=09}
=20
 =09if (ctx->seen & SHMEM_SEEN_QUOTA &&
 =09    !sb_any_quota_loaded(fc->root->d_sb)) {

base-commit: 0d7bee10beeb59b1133bf5a4749b17a4ef3bbb01
--=20
2.51.1



