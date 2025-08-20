Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE173CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 20:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169D48E0022; Wed, 20 Aug 2025 16:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B688E0010; Wed, 20 Aug 2025 16:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A428E0022; Wed, 20 Aug 2025 16:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E37098E0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:23:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9E3C551B9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:23:24 +0000 (UTC)
X-FDA: 83798260728.27.FABEC10
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7302FC000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:23:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d1XdoT35;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755721401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xar26Fk7Vgh0oRtfSyJq7JbIEeQDQwbrb9OyTQGXg9c=;
	b=zTZ83H6mWtUQI2mCrsG/3GjEsUeqqm/XfE4vBJv04MgteItGkUs1q/7EWs7BJJGuU4IOXE
	vuaWu8RM7Gg82tADK5KLtlcKAgsWUpg5crBy9C/K+kcI9wCx4Bgn2O5Up2p50WdjstI2rX
	PxfT0jBdjaaFBryrKJsR4P4Ll9JTIWM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d1XdoT35;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755721401; a=rsa-sha256;
	cv=none;
	b=PzqRkGv8iO21tUbTy3NHnQ14N8nlpejD8noqbcAOJUIHyMMF5ChaAKT5O27udWKX7ofGZg
	N8AsOp90VCQSfQP2is5DGcv6YZu5Clbxc2zKMD331vaai/yfmtAROLQdXKzu2JdiI18XFT
	RJ9tY0JlsD8jSGse9L3TEXn+NDtRvQg=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-324e3a0482dso243240a91.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755721400; x=1756326200; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xar26Fk7Vgh0oRtfSyJq7JbIEeQDQwbrb9OyTQGXg9c=;
        b=d1XdoT35l+XbYmXH2doAuG768GR5sMX8fKpKKvqx5w1oZsBBhYPiK+L0t/5KKtSNuU
         b1TFtQfKv6qVk0x+tcvZut4KB3MTdbqafO43wYPn71p/163xTQX4JnSZCFqKZPzk15rQ
         VzIBekpQWvzq11nYgbPcUc8tLMvICDtp3SS4qO8SqtFHe2/V8bo55Lpo5x/lXBtg+uU1
         796Y8hbiO6bkVxfzJHgQfl6uIZ+OwDsiWxCfpHihfkASsKvqa0gInTugMTkDOT57sBoV
         7Ur6jIZs0pS4D0OO8pytwkTw87VOvH0jDnjgQ4x8IJetWzjlsM7ffDfJ6NyjDEWhJbFP
         pybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755721400; x=1756326200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xar26Fk7Vgh0oRtfSyJq7JbIEeQDQwbrb9OyTQGXg9c=;
        b=oiAWNGH9DLptt0+HyPFIBBjEaRt07nCWXfx94eMBXT18+gDX25zSIDaJHjPnVKH47B
         +UuuUFcaL1aH7tXLZqZZPMbNV9y3aM7FlINmomQZ7zjh8Elli7fxR02+lRjB4+2JIH2i
         IvNpJUsYQHfxqWK1Mf4mRyGMJHpfSeo/s80lZq/tUSIJ0YEWMhcHGSW6EvwboYy6h6Xp
         H863N3zFrGh+okpYZNqJy8ZLf+/mOS7yAeDot+FheD2J3s4mR+Vk2Jtr0NtmiIH0upQK
         JRD0Qm/QoSo3tMriMm8qmd75yTIEvfAJlqAka8i2UtF9UJfQtxahYEf7fsYNSN8H+SNh
         F7Xw==
X-Gm-Message-State: AOJu0YxNw9nH0TfQYmxd+r1yhnRhP/rLIt/kWJyXAJQIqi7Wk2BXKvHx
	lzPeyU5m4FTskliwN2YBJsbq8EG/tGFdWiMFFo4PydGli48PPLRUVuIj+prfw9omQQ7pzdw7Qg5
	JTaIStSHkYCm+a0aAWdq1uiIj5QvIw4E=
X-Gm-Gg: ASbGncvpAmoMpZYQuabyhGCOBaYHdxOe/ixXMWN2qOPUkY8uwtScIwwTkRzpzcaSZT+
	LfKjb7fvajbecOq3q06qdoieBgFNEOSzgkkGVJ9mgpBf3ML3xCeX4eFkqOo23lfIIWSe6//8bjh
	rDBULgU7DGRlqWfTY6iPn5HoHIU3Zo4HUUqlBEPGflULBXTOA8cDDSSF52grLaZ07dBCRiS2DVX
	wuIjQlaMgbgJNRjq5SCboVzSn9uJEMJYw==
X-Google-Smtp-Source: AGHT+IG/o+jqEz7MRGxhpE50JuhTkZh+GVplyCSf3EZMyZt5fBnjWyasiEEWrfzosT4slxa39kM963FxIztoBJRv9qw=
X-Received: by 2002:a17:90b:2b48:b0:2ee:d371:3227 with SMTP id
 98e67ed59e1d1-324ed1bf522mr209863a91.17.1755721400194; Wed, 20 Aug 2025
 13:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-11-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-11-roman.gushchin@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 20 Aug 2025 13:23:05 -0700
X-Gm-Features: Ac12FXwezbVvL0viCZVuAjNFUFHCHczXXpW3UtjzCHu_V1oLZOOrYvMnXKpxRX4
Message-ID: <CAEf4BzZL+W0AYcr_+6oeV4+uOjam9hFSneCux93GnNRPdyqapA@mail.gmail.com>
Subject: Re: [PATCH v1 10/14] bpf: selftests: bpf OOM handler test
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7302FC000B
X-Stat-Signature: 3jfzun73arqjjwnqz8ac143sfers8ob8
X-Rspam-User: 
X-HE-Tag: 1755721401-901498
X-HE-Meta: U2FsdGVkX1+nmCh+I6qV1kaV/db+cAIXBX49UbU0R2rAPGDE8jR4TQZMQr5v3hiAW5pc2R+2ioYtG0Fp+LFICqh9leydcLa3tztZfjXkKKUlbZ4iuKE5etfuuDCNHZ/Ks+sKzpmqYujmL8D91YnBzBue6gTeiRh6GrL9857sbG2ZUh1oOOXW1QDePItjT6YgPymmi1BbaTVsJAoDdVY3y8IJwWO/zXI3VCpnkMSz03fsXWjn93sRFqhMVjkfmg8PrUZqgXAmXP14wB6GeplXfcjaD5UGwPgIs06Ld4GOjXuHJqwEk9rfRVk4OKKa5YIAeZlrI65yMsE9UtIrLo3fjhWjyJmHG1/fsiFXhln3usBkTGQMHNMMSTT7E/3dC5HCyyNKekJiajXzbRg8Cl9zvuPI0+JXPGSEAT2XqOwPTvV2fUW9xwsejZBkmUDg5uOf/n6pKdB0iKpydABcBBGvMps90Zk1V51XdjH+0KRszE71A97by22FXf4dL0cXCF18q6ySwK9X+rL1nsfBnIlYzNqzs0csFoToEHd6cyKqMFSy6pYT/l3cD4dFRu76TtGrkJatRJHa+Aw3JyY4vrP9Gyq29by9Bh4JhcrRmL3LLj1MUMTIInJqB1k5OsHcRcD0K7jzQUtedmw2N/K6geFRLv9Hn9ppN0gyeEgO55fmIgKGe1YYT9GIa/jJcj6wYGYyHmVDCmXrwXczwceL7WajVZaqYp6Kr5FMRElwEUd2aqj5Orvopl8jLpv6X0orx7rdMt0iZgD+zkIdEmzuKgqBhZdOVc8w/y+BaekjViNNSReBlIsPnximrZUjgkw1c4kHvUVYXaAj46Y9yPf2ieCsFy9vAFhG5uro1yWut+IrbG4th3+ieBwRdEhB96FuTZUgMwZrYxX6komiAnhenFD6qLZYBvNfla5wwbqSi1nnLwZy4SneycFT5Iyf4DnO4KOF2Cob5zK/sHRptGkHxGP
 9SuJ3ILi
 0dZ4qMpOjbVEQpjoRkV7mKaAdhA0E5mPz6ryTSkJO6F/LeTtqvIUZQiHQpmrb6r4QMw/gMDKT+zTmiAqFxh6yEScOBV94sZE1ZsQdbOLFFyAggnvyQDf+2MYPeE/Ee2FKbeo+atYo/vv81iC0CAD0uj24Sg/Gdbo0Bz6RxQ8HqlIdGYabN84s9o8Jyx7Vu/kB5vKawH0kmbrrC1nbl/m6nJQFPZOARxtNb9xbW9MU1vWyWrA+Hi0OiFWZnRXeG12JJIRXR3J5NSyvgsfVKgpRKZCziMgJr3iMOo5f6Itlu0UzvMkUeQN64j0+Vs6qhd1RfBZ34CHrjiHibeidLaer4D/FZqtzFe8hEnGDV9Cqx5meW9hud1lSFDxv/lzXHz0RVAFQKm6KV1VQbAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:05=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Implement a pseudo-realistic test for the OOM handling
> functionality.
>
> The OOM handling policy which is implemented in bpf is to
> kill all tasks belonging to the biggest leaf cgroup, which
> doesn't contain unkillable tasks (tasks with oom_score_adj
> set to -1000). Pagecache size is excluded from the accounting.
>
> The test creates a hierarchy of memory cgroups, causes an
> OOM at the top level, checks that the expected process will be
> killed and checks memcg's oom statistics.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  .../selftests/bpf/prog_tests/test_oom.c       | 229 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/test_oom.c  | 108 +++++++++
>  2 files changed, 337 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_oom.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_oom.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_oom.c b/tools/te=
sting/selftests/bpf/prog_tests/test_oom.c
> new file mode 100644
> index 000000000000..eaeb14a9d18f
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/test_oom.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <test_progs.h>
> +#include <bpf/btf.h>
> +#include <bpf/bpf.h>
> +
> +#include "cgroup_helpers.h"
> +#include "test_oom.skel.h"
> +
> +struct cgroup_desc {
> +       const char *path;
> +       int fd;
> +       unsigned long long id;
> +       int pid;
> +       size_t target;
> +       size_t max;
> +       int oom_score_adj;
> +       bool victim;
> +};
> +
> +#define MB (1024 * 1024)
> +#define OOM_SCORE_ADJ_MIN      (-1000)
> +#define OOM_SCORE_ADJ_MAX      1000
> +
> +static struct cgroup_desc cgroups[] =3D {
> +       { .path =3D "/oom_test", .max =3D 80 * MB},
> +       { .path =3D "/oom_test/cg1", .target =3D 10 * MB,
> +         .oom_score_adj =3D OOM_SCORE_ADJ_MAX },
> +       { .path =3D "/oom_test/cg2", .target =3D 40 * MB,
> +         .oom_score_adj =3D OOM_SCORE_ADJ_MIN },
> +       { .path =3D "/oom_test/cg3" },
> +       { .path =3D "/oom_test/cg3/cg4", .target =3D 30 * MB,
> +         .victim =3D true },
> +       { .path =3D "/oom_test/cg3/cg5", .target =3D 20 * MB },
> +};
> +
> +static int spawn_task(struct cgroup_desc *desc)
> +{
> +       char *ptr;
> +       int pid;
> +
> +       pid =3D fork();
> +       if (pid < 0)
> +               return pid;
> +
> +       if (pid > 0) {
> +               /* parent */
> +               desc->pid =3D pid;
> +               return 0;
> +       }
> +
> +       /* child */
> +       if (desc->oom_score_adj) {
> +               char buf[64];
> +               int fd =3D open("/proc/self/oom_score_adj", O_WRONLY);
> +
> +               if (fd < 0)
> +                       return -1;
> +
> +               snprintf(buf, sizeof(buf), "%d", desc->oom_score_adj);
> +               write(fd, buf, sizeof(buf));
> +               close(fd);
> +       }
> +
> +       ptr =3D (char *)malloc(desc->target);
> +       if (!ptr)
> +               return -ENOMEM;
> +
> +       memset(ptr, 'a', desc->target);
> +
> +       while (1)
> +               sleep(1000);
> +
> +       return 0;
> +}
> +
> +static void setup_environment(void)
> +{
> +       int i, err;
> +
> +       err =3D setup_cgroup_environment();
> +       if (!ASSERT_OK(err, "setup_cgroup_environment"))
> +               goto cleanup;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(cgroups); i++) {
> +               cgroups[i].fd =3D create_and_get_cgroup(cgroups[i].path);
> +               if (!ASSERT_GE(cgroups[i].fd, 0, "create_and_get_cgroup")=
)
> +                       goto cleanup;
> +
> +               cgroups[i].id =3D get_cgroup_id(cgroups[i].path);
> +               if (!ASSERT_GT(cgroups[i].id, 0, "get_cgroup_id"))
> +                       goto cleanup;
> +
> +               /* Freeze the top-level cgroup */
> +               if (i =3D=3D 0) {
> +                       /* Freeze the top-level cgroup */
> +                       err =3D write_cgroup_file(cgroups[i].path, "cgrou=
p.freeze", "1");
> +                       if (!ASSERT_OK(err, "freeze cgroup"))
> +                               goto cleanup;
> +               }
> +
> +               /* Recursively enable the memory controller */
> +               if (!cgroups[i].target) {
> +
> +                       err =3D write_cgroup_file(cgroups[i].path, "cgrou=
p.subtree_control",
> +                                               "+memory");
> +                       if (!ASSERT_OK(err, "enable memory controller"))
> +                               goto cleanup;
> +               }
> +
> +               /* Set memory.max */
> +               if (cgroups[i].max) {
> +                       char buf[256];
> +
> +                       snprintf(buf, sizeof(buf), "%lu", cgroups[i].max)=
;
> +                       err =3D write_cgroup_file(cgroups[i].path, "memor=
y.max", buf);
> +                       if (!ASSERT_OK(err, "set memory.max"))
> +                               goto cleanup;
> +
> +                       snprintf(buf, sizeof(buf), "0");
> +                       write_cgroup_file(cgroups[i].path, "memory.swap.m=
ax", buf);
> +
> +               }
> +
> +               /* Spawn tasks creating memory pressure */
> +               if (cgroups[i].target) {
> +                       char buf[256];
> +
> +                       err =3D spawn_task(&cgroups[i]);
> +                       if (!ASSERT_OK(err, "spawn task"))
> +                               goto cleanup;
> +
> +                       snprintf(buf, sizeof(buf), "%d", cgroups[i].pid);
> +                       err =3D write_cgroup_file(cgroups[i].path, "cgrou=
p.procs", buf);
> +                       if (!ASSERT_OK(err, "put child into a cgroup"))
> +                               goto cleanup;
> +               }
> +       }
> +
> +       return;
> +
> +cleanup:
> +       cleanup_cgroup_environment();
> +}
> +
> +static int run_and_wait_for_oom(void)
> +{
> +       int ret =3D -1;
> +       bool first =3D true;
> +       char buf[4096] =3D {};
> +       size_t size;
> +
> +       /* Unfreeze the top-level cgroup */
> +       ret =3D write_cgroup_file(cgroups[0].path, "cgroup.freeze", "0");
> +       if (!ASSERT_OK(ret, "freeze cgroup"))
> +               return -1;
> +
> +       for (;;) {
> +               int i, status;
> +               pid_t pid =3D wait(&status);
> +
> +               if (pid =3D=3D -1) {
> +                       if (errno =3D=3D EINTR)
> +                               continue;
> +                       /* ECHILD */
> +                       break;
> +               }
> +
> +               if (!first)
> +                       continue;
> +
> +               first =3D false;
> +
> +               /* Check which process was terminated first */
> +               for (i =3D 0; i < ARRAY_SIZE(cgroups); i++) {
> +                       if (!ASSERT_OK(cgroups[i].victim !=3D
> +                                      (pid =3D=3D cgroups[i].pid),
> +                                      "correct process was killed")) {
> +                               ret =3D -1;
> +                               break;
> +                       }
> +
> +                       if (!cgroups[i].victim)
> +                               continue;
> +
> +                       /* Check the memcg oom counter */
> +                       size =3D read_cgroup_file(cgroups[i].path,
> +                                               "memory.events",
> +                                               buf, sizeof(buf));
> +                       if (!ASSERT_OK(size <=3D 0, "read memory.events")=
) {
> +                               ret =3D -1;
> +                               break;
> +                       }
> +
> +                       if (!ASSERT_OK(strstr(buf, "oom_kill 1") =3D=3D N=
ULL,
> +                                      "oom_kill count check")) {
> +                               ret =3D -1;
> +                               break;
> +                       }
> +               }
> +
> +               /* Kill all remaining tasks */
> +               for (i =3D 0; i < ARRAY_SIZE(cgroups); i++)
> +                       if (cgroups[i].pid && cgroups[i].pid !=3D pid)
> +                               kill(cgroups[i].pid, SIGKILL);
> +       }
> +
> +       return ret;
> +}
> +
> +void test_oom(void)
> +{
> +       struct test_oom *skel;
> +       int err;
> +
> +       setup_environment();
> +
> +       skel =3D test_oom__open_and_load();
> +       err =3D test_oom__attach(skel);
> +       if (CHECK_FAIL(err))
> +               goto cleanup;
> +
> +       /* Unfreeze all child tasks and create the memory pressure */
> +       err =3D run_and_wait_for_oom();
> +       CHECK_FAIL(err);
> +
> +cleanup:
> +       cleanup_cgroup_environment();
> +       test_oom__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_oom.c b/tools/testing=
/selftests/bpf/progs/test_oom.c
> new file mode 100644
> index 000000000000..ca83563fc9a8
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_oom.c
> @@ -0,0 +1,108 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") =3D "GPL";
> +
> +#define OOM_SCORE_ADJ_MIN      (-1000)
> +
> +void bpf_rcu_read_lock(void) __ksym;
> +void bpf_rcu_read_unlock(void) __ksym;
> +struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
> +void bpf_task_release(struct task_struct *p) __ksym;
> +struct mem_cgroup *bpf_get_root_mem_cgroup(void) __ksym;
> +struct mem_cgroup *bpf_get_mem_cgroup(struct cgroup_subsys_state *css) _=
_ksym;
> +void bpf_put_mem_cgroup(struct mem_cgroup *memcg) __ksym;
> +int bpf_oom_kill_process(struct oom_control *oc, struct task_struct *tas=
k,
> +                        const char *message__str) __ksym;

These declarations should come from vmlinux.h, if you don't get them,
you might not have recent enough pahole.

At the very least these should all be __ksym __weak, not just __ksym
(but I'd rather not add them, though).

[...]

