Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C526C531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136756B009E; Thu, 23 Jul 2026 11:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E356B009F; Thu, 23 Jul 2026 11:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A186B00A2; Thu, 23 Jul 2026 11:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9BFF6B009E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:07:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4650514025F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:07:35 +0000 (UTC)
X-FDA: 85020370470.11.92E4E12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A56631C0011
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:07:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tzQHUghdrVrIrOI0vJOosaA1fJi+VhG4ztN+axtl+o8=;
	b=MwK4cfRP3UKtcxJs7/kNTaQMW9VaW9sFm4nqTo5P6vTyGCjgDR5jGj//jpbotrTrDMIyIk
	HaRFeATCNj7fEqUGfE7MBSTjXT/NpBjg2XLUG0wNPq10skbMAzz6VJE1QNW0KGQhK82Del
	/kzsYVdvAofQNV2vQeH//79Lh+F3bvM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819253;
	b=hTupbTC+5C/t89uVGNIZuCFZdNxjyObeXBBNwhnuaUry5EqDMdFsW7p+EKP/N17qu7hIM0
	Oxygy4kqeUSIO2y3qb12OpmRbin+xlogOCY+SsVSgYDWqKcOtV2tV67p2BROjejZL6lR0j
	SX/sayq4R8yJXsHV11TbDaL5JwQ6aM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89F7040B4A;
	Thu, 23 Jul 2026 15:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC831F00A3A;
	Thu, 23 Jul 2026 15:07:25 +0000 (UTC)
Content-Type: multipart/mixed; boundary="===============8746857589958803762=="
MIME-Version: 1.0
Message-Id: <cd7b155ba1d02f1a0de26dbac9529e0fce0561ba3e4335fe206b99ef0ab5ae60@mail.kernel.org>
In-Reply-To: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
References: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
Subject: Re: [PATCH] tools: Use fputc() calls in some functions
From: bot+bpf-ci@kernel.org
To: Markus.Elfring@web.de, acpica-devel@lists.linux.dev,
	bpf@vger.kernel.org, coresight@lists.linaro.org, kvm@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mptcp@lists.linux.dev,
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	virtualization@lists.linux.dev, adrian.hunter@intel.com,
	amastro@fb.com, alex@shazbot.org, alexander.shishkin@linux.intel.com,
	ast@kernel.org, ak@linux.intel.com, andrew+netdev@lunn.ch,
	akpm@linux-foundation.org, andrii@kernel.org,
	ankur.a.arora@oracle.com, acme@kernel.org, brgl@kernel.org,
	bobbyeshleman@meta.com, borntraeger@linux.ibm.com,
	chleroy@kernel.org, ctshao@google.com, imbrenda@linux.ibm.com,
	costa.shul@redhat.com, crwood@redhat.com, daniel@iogearbox.net,
	daniel.lezcano@kernel.org, david@kernel.org, dmatlack@google.com,
	davem@davemloft.ne, t@kvack.org, donald.hunter@gmail.com,
	eddyz87@gmail.com, emil@etsalapatis.com, edumazet@google.com,
	gmonaco@redhat.com, geliang@kernel.org, irogers@google.com,
	mingo@redhat.com, ipravdin.official@gmail.com, kuba@kernel.org,
	james.clark@linaro.org, frankja@linux.ibm.com,
	kerneljasonxing@gmail.com, jolsa@kernel.org, joe@dama.to,
	john.g.garry@oracle.com, jpoimboe@kernel.org,
	kaushlendra.kumar@intel.com, warthog618@gmail.com, memxor@gmail.com,
	lenb@kernel.org, leo.yan@linux.dev, lukasz.luba@arm.com,
	maddy@linux.ibm.com, mark.rutland@arm.com, martin.lau@linux.dev,
	mhiramat@kernel.org, martineau@kernel.org, matttbe@kernel.org,
	mpe@ellerman.id.au, mike.leach@arm.com, almasrymina@google.com,
	yatsenko@meta.com, namcao@linutronix.de, namhyung@kernel.org,
	npiggin@gmail.com, pabeni@redhat.com, pbonzini@redhat.com,
	pawel.chmielewski@intel.com, peterz@infradead.org, qmo@kernel.org,
	rafael@kernel.org, rananta@google.com, saket.dumbre@intel.com,
	shuah@kernel.org, horms@kernel.org, song@kernel.org,
	srinivas.pandruvada@linux.intel.com, sdf@fomichev.me,
	sgarza@kvack.org, re@redhat.com, rostedt@goodmis.org,
	suzuki.poulose@arm.com, swapnil.sapkal@amd.com, linux@weissschuh.net,
	tglozar@redhat.com, vipinsh@google.com, wander@redhat.com,
	will@kernel.org, willemdebruijn.kernel@gmail.com, w@1wt.eu,
	yonghong.song@linux.dev, zhangchujun@cmss.chinamobile.com,
	rui.zhang@intel.com
Cc: linux-kernel@vger.kernel.org,kernel-janitors@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 23 Jul 2026 15:07:25 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: A56631C0011
X-Rspamd-Server: rspam01
X-Stat-Signature: 16p16u49sn8tt4kpaqh66e3kr9p4a6ry
X-HE-Tag: 1784819253-102807
X-HE-Meta: U2FsdGVkX19PAXpRWpSr2PGkse11hVGzIt+ZdYFJ9LAYIf7VoFqmtjXSfEhRTu69ekXZnDa4skWepTAn3E1/VXY3KA2nWsKZYAKX/75RyEcxcJnxCeCUYFrdad7QNCYs2zFThmQS/Rn6YERhox6625WyGPPXVk5egj+u/bHlo8J8yb9t8JuEkkSlUjWbzuNBHf0P32nSaCp1n29Un1ujv0laIfvxqZiHGeKX/uBZDAYhDwSbhrOASyPnR/wxsAMIh0VUPOEsTD9t/RiGwx69nk0gf6/pTg/iG3yZLiRCeOkL1XmCcUBhy4YOQz2Ercd5cBA6O9D3Ve0vUASJA5v0P/Ylo8a5VbeBwMJWIuQDXL4G2nAbiwVav2SOkyx93ETsP6Q09ED2Od0zX5nQAbdvgWZ8n6SFvZN+Y3ewk2Bx3qNDw8tXaOwpHJ+LXi3yahoKwGU7GUutiD2gcE10cIqyHHimW1adc0QKmgaPNR/aai+wVIOpgFYr4Ffmgh4bLagrsfT4CgTptzNr7kklus7N7e4+seIrzRHkDZdYKSQfgg56V5n5VcZqf81tg9jaVMmuWbG1dJ28HGxKXwmYxT8GxZvWVPWxi1vIPvnsGxkrPd5WGQSNxA0wrpOdz/aNub0eSJbyAeyyFN2GeoD/LclXNwRAy0tsBS58xSlc/920RExLC3Tpb6hOoIpcy/FMRTibL4fA1ccsO1BoWgL6+4UNao8vFbcWJlSjqpbeqaKC3VGAhO7zZjvl1KV3VeGE1P7B2BRr2GgWYIyCEUUQqFNSBaebYCC/1ovxH596QLFiodTzAS+XQqh15clSQrX+Yk9LSqeCMe/k22DrgqaMbTSP4DP5+8r1uuMTqMZqvUAoSRRNp6t+HaCZtDQKgLPtXqsvJnwjkCn3AmWrpusUPzT/kh0Z2gF93Lpm/hVk9XWM6ylTxIo2L4o2d+4YgB4+uZGmzi9fhevGIPyg4BkeG6J
 YVavePqc
 UAcmizdEET/hP4hyFehISfRJbCDbYZJH/JFKq61o+wDJzTbcs2quoCcxw+oxcQDZo/fnrmpjW8RTshklEnD08G9hocrmiFRnQXG72DaPlSzcj0hoYIOPsWbBje73bqFNL98mpr+6NuEwlD9Am10FKqlcB+JY16XqSbjsEkp7GJT51b1I02ftQ6bWM7n1y1R8MlvE6foqaI5fNpvYXN0ke/NtUpV1PEHku62F5Y845iKsJGzOzgCANO+z7/WoeyLAlA0xNVGsOwTG96ZUrELca2nlyHWKEyasZ2Lzdu0+rZyFABgHDy8SkWAFlE8YxesXiQnScl7qh6sg321ByEWkrYwLkia3OYJ6ClilIn+whAoYhXAWizkDwDhZ/ajWr26r21KDkiR6BwbcupkkAPhzitsGZnfNf4G9qGu8tSlJN521ywh1mWgakJAoDVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8746857589958803762==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -53,7 +53,7 @@ void p_err(const char *fmt, ...)
>  	} else {
>  		fprintf(stderr, "Error: ");
>  		vfprintf(stderr, fmt, ap);
> -		fprintf(stderr, "\n");
> +		fputc(stderr, '\n');
                     ^^^^^^

The fputc() arguments are reversed. The C standard signature is
`int fputc(int c, FILE *stream)` - the character comes first, the stream
second. This passes the FILE* stderr as the int c parameter and '\n' as
the FILE* stream parameter.

Correct form is `fputc('\n', stderr)`.

This constraint violation triggers a -Werror=int-conversion diagnostic and
breaks the build. If it compiled, at runtime fputc would dereference
(FILE*)10, crashing the program.

The same argument reversal occurs in 67 conversions across this patch.

> @@ -67,7 +67,7 @@ void p_info(const char *fmt, ...)
>
>  	va_start(ap, fmt);
>  	vfprintf(stderr, fmt, ap);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
                     ^^^^^^

Same reversed-argument bug.

> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -273,7 +273,7 @@ void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep)
>  		if (!i)
>  			/* nothing */;
>  		else if (!(i % 16))
> -			fprintf(f, "\n");
> +			fputc(f, '\n');

Arguments reversed: `fputc(f, '\n')` should be `fputc('\n', f)`.

> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1266,7 +1266,7 @@ static void hex_print(void *data, unsigned int size, FILE *f)
>  			fprintf(f, "%c%s", c, j == i + 7 ? " " : "");
>  		}
>
> -		fprintf(f, "\n");
> +		fputc(f, '\n');

Arguments reversed.

> diff --git a/tools/include/nolibc/err.h b/tools/include/nolibc/err.h
> --- a/tools/include/nolibc/err.h
> +++ b/tools/include/nolibc/err.h
> @@ -27,7 +27,7 @@ void vwarnx(const char *fmt, va_list args)
>  {
>  	fprintf(stderr, "%s: ", program_invocation_short_name);
>  	vfprintf(stderr, fmt, args);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Arguments reversed. This is in a nolibc header - nolibc's fputc
(tools/include/nolibc/stdio.h) does `write(fileno(stream), &ch, 1)`.
With stream==(FILE*)10 fileno dereferences a bogus pointer and crashes.

> diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
> --- a/tools/mm/page_owner_sort.c
> +++ b/tools/mm/page_owner_sort.c
> @@ -867,7 +867,7 @@ struct option longopts[] = {
>  			}
>  			if (cull & CULL_STACKTRACE)
>  				fprintf(fout, ":\n%s", list[i].stacktrace);
> -			fprintf(fout, "\n");
> +			fputc(fout, '\n');

Arguments reversed: should be `fputc('\n', fout)`.

> diff --git a/tools/net/ynl/ynltool/main.c b/tools/net/ynl/ynltool/main.c
> --- a/tools/net/ynl/ynltool/main.c
> +++ b/tools/net/ynl/ynltool/main.c
> @@ -156,7 +156,7 @@ void p_err(const char *fmt, ...)
>  	} else {
>  		fprintf(stderr, "Error: ");
>  		vfprintf(stderr, fmt, ap);
> -		fprintf(stderr, "\n");
> +		fputc(stderr, '\n');
>  	}
>  	va_end(ap);
>  }
> @@ -170,7 +170,7 @@ void p_info(const char *fmt, ...)
>
>  	va_start(ap, fmt);
>  	vfprintf(stderr, fmt, ap);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Both conversions reverse the arguments.

> diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
> --- a/tools/objtool/builtin-check.c
> +++ b/tools/objtool/builtin-check.c
> @@ -297,7 +297,7 @@ int make_backup(void)
>  			fprintf(stderr, " %s", arg);
>  	}
>
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Arguments reversed. objtool runs during the kernel build, so a build
failure or crash here breaks the build.

> diff --git a/tools/objtool/disas.c b/tools/objtool/disas.c
> --- a/tools/objtool/disas.c
> +++ b/tools/objtool/disas.c
> @@ -537,7 +537,7 @@ void disas_print_insn(FILE *stream, struct disas_context *dctx,
>  		return;
>
>  	if (strcmp(format, "\n") == 0) {
> -		fprintf(stream, "\n");
> +		fputc(stream, '\n');

Arguments reversed.

> diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> --- a/tools/perf/builtin-c2c.c
> +++ b/tools/perf/builtin-c2c.c
> @@ -2511,7 +2511,7 @@ struct perf_hpp hpp = {
>  		hists__fprintf_headers(&c2c_hists->hists, out);
>  		once = true;
>  	} else {
> -		fprintf(out, "\n");
> +		fputc(out, '\n');
>  	}

[ ... ]

> @@ -2590,15 +2590,15 @@ static void perf_c2c__hists_fprintf(FILE *out, struct perf_session *session)
>  	setup_pager();
>
>  	print_c2c__display_stats(out);
> -	fprintf(out, "\n");
> +	fputc(out, '\n');
>  	print_shared_cacheline_info(out);
> -	fprintf(out, "\n");
> +	fputc(out, '\n');
>  	print_c2c_info(out, session);
>
>  	if (c2c.stats_only)
>  		return;
>
> -	fprintf(out, "\n");
> +	fputc(out, '\n');

[ ... ]

> @@ -2606,7 +2606,7 @@ static void perf_c2c__hists_fprintf(FILE *out, struct perf_session *session)
>
>  	hists__fprintf(&c2c.hists.hists, true, 0, 0, 0, stdout, true);
>
> -	fprintf(out, "\n");
> +	fputc(out, '\n');

All four conversions reverse the arguments.

> diff --git a/tools/perf/builtin-daemon.c b/tools/perf/builtin-daemon.c
> --- a/tools/perf/builtin-daemon.c
> +++ b/tools/perf/builtin-daemon.c
> @@ -691,7 +691,7 @@ static int cmd_session_list(struct daemon *daemon, union cmd *cmd, FILE *out)
>  			/* session up time */
>  			csv_sep, (uint64_t)((curr - daemon->start) / 60));
>
> -		fprintf(out, "\n");
> +		fputc(out, '\n');
>  	} else {

[ ... ]

> @@ -730,7 +730,7 @@
>  				/* session up time */
>  				csv_sep, (uint64_t)((curr - session->start) / 60));
>
> -			fprintf(out, "\n");
> +			fputc(out, '\n');

Both conversions reverse the arguments.

> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -1319,9 +1319,9 @@ static void print_result(void)
>
>  		list_for_each_entry(key, &lock_keys, list) {
>  			key->print(key, st);
> -			fprintf(lock_output, " ");
> +			fputc(lock_output, ' ');
>  		}
> -		fprintf(lock_output, "\n");
> +		fputc(lock_output, '\n');

Both `fputc(lock_output, ' ')` and `fputc(lock_output, '\n')` reverse the
arguments. Correct form: `fputc(' ', lock_output)` and
`fputc('\n', lock_output)`.

> @@ -1598,7 +1598,7 @@ static void print_header_csv(const char *sep)
>  		fprintf(lock_output, "%s%s %s", "type", sep, "caller");
>  		if (verbose > 0)
>  			fprintf(lock_output, "%s %s", sep, "stacktrace");
> -		fprintf(lock_output, "\n");
> +		fputc(lock_output, '\n');

[ ... ]

> @@ -1629,7 +1629,7 @@ static void print_lock_stat_stdio(struct lock_contention *con, struct lock_stat *st)
>
>  	list_for_each_entry(key, &lock_keys, list) {
>  		key->print(key, st);
> -		fprintf(lock_output, " ");
> +		fputc(lock_output, ' ');
>  	}

[ ... ]

> @@ -1687,7 +1687,7 @@ static void print_lock_stat_csv(struct lock_contention *con, struct lock_stat *st,
>  	case LOCK_AGGR_CALLER:
>  		fprintf(lock_output, "%s%s %s", get_type_flags_name(st->flags), sep, st->name);
>  		if (verbose <= 0)
> -			fprintf(lock_output, "\n");
> +			fputc(lock_output, '\n');

[ ... ]

> @@ -1721,7 +1721,7 @@ static void print_lock_stat_csv(struct lock_contention *con, struct lock_stat *st,
>  			get_symbol_name_offset(kmap, sym, ip, buf, sizeof(buf));
>  			fprintf(lock_output, "%s %#lx %s", i ? ":" : sep, (unsigned long) ip, buf);
>  		}
> -		fprintf(lock_output, "\n");
> +		fputc(lock_output, '\n');
>  	}
>  }

[ ... ]

> @@ -1781,7 +1781,7 @@ static void print_footer_csv(int total, int bad, struct lock_contention_fails *fails,
>  		for (i = 0; i < BROKEN_MAX; i++)
>  			fprintf(lock_output, "%s bad_%s=%d", sep, name[i], bad_hist[i]);
>  	}
> -	fprintf(lock_output, "\n");
> +	fputc(lock_output, '\n');

All six conversions in builtin-lock.c reverse the arguments.

> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -2561,7 +2561,7 @@
>
>  	perf_sample__fprintf_ipc(sample, evsel, fp);
>
> -	fprintf(fp, "\n");
> +	fputc(fp, '\n');

[ ... ]

> @@ -2815,7 +2815,7 @@
>  				    cursor, symbol_conf.bt_stop_list, fp);
>  	}
>
> -	fprintf(fp, "\n");
> +	fputc(fp, '\n');

[ ... ]

> @@ -3271,11 +3271,11 @@ static int list_available_languages_cb(struct scripting_ops *ops, const char *spec)
>
>  static void list_available_languages(void)
>  {
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  	fprintf(stderr, "Scripting language extensions (used in "
>  		"perf script -s [spec:]script.[spec]):\n\n");
>  	script_spec__for_each(&list_available_languages_cb);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

All four conversions reverse the arguments.

> diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
> --- a/tools/perf/ui/gtk/util.c
> +++ b/tools/perf/ui/gtk/util.c
> @@ -37,7 +37,7 @@ static int perf_gtk__error(const char *format, va_list args)
>  	    vasprintf(&msg, format, args) < 0) {
>  		fprintf(stderr, "Error:\n");
>  		vfprintf(stderr, format, args);
> -		fprintf(stderr, "\n");
> +		fputc(stderr, '\n');
>  		return -1;
>  	}
>
> @@ -62,7 +62,7 @@ static int perf_gtk__warning_info_bar(const char *format, va_list args)
>  	    vasprintf(&msg, format, args) < 0) {
>  		fprintf(stderr, "Warning:\n");
>  		vfprintf(stderr, format, args);
> -		fprintf(stderr, "\n");
> +		fputc(stderr, '\n');
>  		return -1;
>  	}
>
> @@ -83,7 +83,7 @@ static int perf_gtk__warning_statusbar(const char *format, va_list args)
>  	    vasprintf(&msg, format, args) < 0) {
>  		fprintf(stderr, "Warning:\n");
>  		vfprintf(stderr, format, args);
> -		fprintf(stderr, "\n");
> +		fputc(stderr, '\n');

All three conversions reverse the arguments.

> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -691,7 +691,7 @@
>  		}
>
>  next_line:
> -		fprintf(fp, "\n");
> +		fputc(fp, '\n');
>  	}

[ ... ]

> @@ -783,7 +783,7 @@ hists__fprintf_standard_headers(struct hists *hists,
>  		if (line)
>  			fprintf(fp, "# ");
>  		fprintf_line(hists, hpp, line, fp);
> -		fprintf(fp, "\n");
> +		fputc(fp, '\n');
>  	}

[ ... ]

> @@ -806,10 +806,10 @@ hists__fprintf_standard_headers(struct hists *hists,
>
>  		width = fmt->width(fmt, hpp, hists);
>  		for (i = 0; i < width; i++)
> -			fprintf(fp, ".");
> +			fputc(fp, '.');
>  	}
>
> -	fprintf(fp, "\n");
> +	fputc(fp, '\n');

All four conversions reverse the arguments.

> diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
> --- a/tools/perf/util/debug.c
> +++ b/tools/perf/util/debug.c
> @@ -350,7 +350,7 @@ void __dump_stack(FILE *file, void **stackdump, size_t stackdump_size)
>  			fprintf(file, "    #%zd %p ", i, stackdump[i]);
>
>  		map__fprintf_srcline(al.map, al.addr, "", file);
> -		fprintf(file, "\n");
> +		fputc(file, '\n');

Arguments reversed.

> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2454,7 +2454,7 @@ static void __print_pmu_caps(FILE *fp, int nr_caps, char **caps, char *pmu_name)
>  		delimiter = ", ";
>  	}
>
> -	fprintf(fp, "\n");
> +	fputc(fp, '\n');
>  }

[ ... ]

> @@ -2513,7 +2513,7 @@ static void print_pmu_mappings(struct feat_fd *ff, FILE *fp)
>  		pmu_num--;
>  	}
>
> -	fprintf(fp, "\n");
> +	fputc(fp, '\n');

[ ... ]

> @@ -4349,7 +4349,7 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
>  			fprintf(fp, "%s ", feat_ops[bit].name);
>  	}
>
> -	fprintf(fp, "\n");
> +	fputc(fp, '\n');

All three conversions reverse the arguments.

> diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-log.c b/tools/perf/util/intel-pt-decoder/intel-pt-log.c
> --- a/tools/perf/util/intel-pt-decoder/intel-pt-log.c
> +++ b/tools/perf/util/intel-pt-decoder/intel-pt-log.c
> @@ -70,14 +70,14 @@ static void intel_pt_print_data(const unsigned char *buf, int len, uint64_t pos,
>  	int i;
>
>  	for (i = 0; i < indent; i++)
> -		fprintf(f, " ");
> +		fputc(f, ' ');
>
>  	fprintf(f, "  %08" PRIx64 ": ", pos);
>  	for (i = 0; i < len; i++)
>  		fprintf(f, " %02x", buf[i]);
>  	for (; i < 16; i++)
>  		fprintf(f, "   ");
> -	fprintf(f, " ");
> +	fputc(f, ' ');
>  }
>
>  static void intel_pt_print_no_data(uint64_t pos, int indent)
> @@ -85,12 +85,12 @@ static void intel_pt_print_no_data(uint64_t pos, int indent)
>  	int i;
>
>  	for (i = 0; i < indent; i++)
> -		fprintf(f, " ");
> +		fputc(f, ' ');
>
>  	fprintf(f, "  %08" PRIx64 ": ", pos);
>  	for (i = 0; i < 16; i++)
>  		fprintf(f, "   ");
> -	fprintf(f, " ");
> +	fputc(f, ' ');
>  }

All four conversions reverse the arguments.

> diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
> --- a/tools/perf/util/libbfd.c
> +++ b/tools/perf/util/libbfd.c
> @@ -603,7 +603,7 @@
>  		} else
>  			srcline = NULL;
>
> -		fprintf(s, "\n");
> +		fputc(s, '\n');

Arguments reversed. The variable s is an open_memstream() stream.

> diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
> --- a/tools/perf/util/stat-display.c
> +++ b/tools/perf/util/stat-display.c
> @@ -529,7 +529,7 @@ static void print_metric_json(struct perf_stat_config *config __maybe_unused,
>  		}
>  	}
>  	if (!config->metric_only)
> -		fprintf(out, "}");
> +		fputc(out, '}');
>  }

[ ... ]

> @@ -1316,7 +1316,7 @@ static void print_header_std(struct perf_stat_config *config,
>  	FILE *output = config->output;
>  	int i;
>
> -	fprintf(output, "\n");
> +	fputc(output, '\n');
>  	fprintf(output, " Performance counter stats for ");

[ ... ]

> @@ -1333,7 +1333,7 @@ static void print_header_std(struct perf_stat_config *config,
>  	else
>  		fprintf(output, "thread id \'%s", _target->tid);
>
> -	fprintf(output, "\'");
> +	fputc(output, '\'');

[ ... ]

> @@ -1406,9 +1406,9 @@ static void print_table(struct perf_stat_config *config, FILE *output, double avg)
>  		fprintf(output, " %17.9f (%+.9f) ", run, run - avg);
>
>  		for (h = 0; h < n; h++)
> -			fprintf(output, "#");
> +			fputc(output, '#');
>
> -		fprintf(output, "\n");
> +		fputc(output, '\n');
>  	}

[ ... ]

> @@ -1428,7 +1428,7 @@ static void print_footer(struct perf_stat_config *config)
>  		return;
>
>  	if (!config->null_run)
> -		fprintf(output, "\n");
> +		fputc(output, '\n');

All six conversions reverse the arguments.

> diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
> --- a/tools/perf/util/values.c
> +++ b/tools/perf/util/values.c
> @@ -217,7 +217,7 @@ static void perf_read_values__display_pretty(FILE *fp,
>  	fprintf(fp, "# %*s  %*s", pidwidth, "PID", tidwidth, "TID");
>  	for (j = 0; j < values->num_counters; j++)
>  		fprintf(fp, "  %*s", counterwidth[j], evsel__name(values->counters[j]));
> -	fprintf(fp, "\n");
> +	fputc(fp, '\n');

[ ... ]

> @@ -225,7 +225,7 @@ static void perf_read_values__display_pretty(FILE *fp,
>  		for (j = 0; j < values->num_counters; j++)
>  			fprintf(fp, "  %*" PRIu64,
>  				counterwidth[j], values->value[i][j]);
> -		fprintf(fp, "\n");
> +		fputc(fp, '\n');

Both conversions reverse the arguments.

> diff --git a/tools/power/acpi/tools/acpidump/apdump.c b/tools/power/acpi/tools/acpidump/apdump.c
> --- a/tools/power/acpi/tools/acpidump/apdump.c
> +++ b/tools/power/acpi/tools/acpidump/apdump.c
> @@ -171,7 +171,7 @@ ap_dump_table_buffer(struct acpi_table_header *table,
>  	acpi_ut_dump_buffer_to_file(gbl_output_file,
>  				    ACPI_CAST_PTR(u8, table), table_length,
>  				    DB_BYTE_DISPLAY, 0);
> -	fprintf(gbl_output_file, "\n");
> +	fputc(gbl_output_file, '\n');

Arguments reversed.

> diff --git a/tools/power/x86/intel-speed-select/isst-display.c b/tools/power/x86/intel-speed-select/isst-display.c
> --- a/tools/power/x86/intel-speed-select/isst-display.c
> +++ b/tools/power/x86/intel-speed-select/isst-display.c
> @@ -122,7 +122,7 @@ static void format_and_print(FILE *outf, int level, char *header, char *value)
>
>  	if (level == 0) {
>  		if (header)
> -			fprintf(outf, "{");
> +			fputc(outf, '{');

[ ... ]

> @@ -138,7 +138,7 @@ static void format_and_print(FILE *outf, int level, char *header, char *value)
>
>  		if (value) {
>  			if (last_level != level)
> -				fprintf(outf, "\n");
> +				fputc(outf, '\n');

[ ... ]

> @@ -156,7 +156,7 @@ static void format_and_print(FILE *outf, int level, char *header, char *value)
>  					fprintf(outf, "\n%s}", delimiters);
>  			}
>  			if (abs(last_level - level) < 3)
> -				fprintf(outf, "\n");
> +				fputc(outf, '\n');

All three conversions reverse the arguments.

> diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
> --- a/tools/power/x86/turbostat/turbostat.c
> +++ b/tools/power/x86/turbostat/turbostat.c
> @@ -9099,7 +9099,7 @@ void dump_cpuid_hypervisor(void)
>  	dump_word_chars(ebx);
>  	dump_word_chars(ecx);
>  	dump_word_chars(edx);
> -	fprintf(outf, "\n");
> +	fputc(outf, '\n');
>  }

[ ... ]

> @@ -9749,7 +9749,7 @@
>  		fprintf(outf, " siblings");
>  		for (ht_id = 0; ht_id <= MAX_HT_ID; ++ht_id)
>  			fprintf(outf, " %d", cpus[i].ht_sibling_cpu_id[ht_id]);
> -		fprintf(outf, "\n");
> +		fputc(outf, '\n');

Both conversions reverse the arguments.

> diff --git a/tools/testing/selftests/bpf/benchs/bench_htab_mem.c b/tools/testing/selftests/bpf/benchs/bench_htab_mem.c
> --- a/tools/testing/selftests/bpf/benchs/bench_htab_mem.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_htab_mem.c
> @@ -148,7 +148,7 @@ static const struct htab_mem_use_case *htab_mem_find_use_case_or_exit(const char *name)
>  	fprintf(stderr, "available use case:");
>  	for (i = 0; i < ARRAY_SIZE(use_cases); i++)
>  		fprintf(stderr, " %s", use_cases[i].name);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/testing/selftests/bpf/jit_disasm_helpers.c b/tools/testing/selftests/bpf/jit_disasm_helpers.c
> --- a/tools/testing/selftests/bpf/jit_disasm_helpers.c
> +++ b/tools/testing/selftests/bpf/jit_disasm_helpers.c
> @@ -228,7 +228,7 @@ struct bpf_prog_info info = {};
>  	for (pc = 0, i = 0; i < jited_funcs; ++i) {
>  		fprintf(text_out, "func #%d:\n", i);
>  		disasm_one_func(text_out, image + pc, func_lens[i]);
> -		fprintf(text_out, "\n");
> +		fputc(text_out, '\n');

Arguments reversed.

> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -383,7 +383,7 @@ static void print_test_result(const struct prog_test_def *test, const struct test_state *test_state)
>  	else
>  		fprintf(env.stdout_saved, "OK (SKIP: %d/%d)", skipped_cnt, subtests_cnt);
>
> -	fprintf(env.stdout_saved, "\n");
> +	fputc(env.stdout_saved, '\n');
>  }

[ ... ]

> @@ -391,7 +391,7 @@ static void print_test_log(char *log_buf, size_t log_cnt)
>  	log_buf[log_cnt] = '\0';
>  	fprintf(env.stdout_saved, "%s", log_buf);
>  	if (log_buf[log_cnt - 1] != '\n')
> -		fprintf(env.stdout_saved, "\n");
> +		fputc(env.stdout_saved, '\n');
>  }

[ ... ]

> @@ -409,7 +409,7 @@ static void print_subtest_name(int test_num, int subtest_num,
>  	if (result)
>  		fprintf(env.stdout_saved, ":%s", result);
>
> -	fprintf(env.stdout_saved, "\n");
> +	fputc(env.stdout_saved, '\n');

All three conversions reverse the arguments.

> diff --git a/tools/testing/selftests/drivers/net/hw/ncdevmem.c b/tools/testing/selftests/drivers/net/hw/ncdevmem.c
> --- a/tools/testing/selftests/drivers/net/hw/ncdevmem.c
> +++ b/tools/testing/selftests/drivers/net/hw/ncdevmem.c
> @@ -135,7 +135,7 @@ static void pr_err(const char *fmt, ...)
>
>  	if (errno != 0)
>  		fprintf(stderr, ": %s", strerror(errno));
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/testing/selftests/kvm/s390/keyop.c b/tools/testing/selftests/kvm/s390/keyop.c
> --- a/tools/testing/selftests/kvm/s390/keyop.c
> +++ b/tools/testing/selftests/kvm/s390/keyop.c
> @@ -117,7 +117,7 @@ static void dump_sk(const unsigned char skeys[], const char *descr)
>  		fprintf(stderr, "# %3d: ", i);
>  		for (j = 0; j < 32; j++)
>  			fprintf(stderr, "%02x ", skeys[i + j]);
> -		fprintf(stderr, "\n");
> +		fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> --- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> +++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> @@ -208,7 +208,7 @@
>  		}
>  		if (server_side)
>  			fprintf(stderr, ",server_side:1");
> -		fprintf(stderr, "\n");
> +		fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/testing/selftests/net/psock_tpacket.c b/tools/testing/selftests/net/psock_tpacket.c
> --- a/tools/testing/selftests/net/psock_tpacket.c
> +++ b/tools/testing/selftests/net/psock_tpacket.c
> @@ -116,7 +116,7 @@ static int pfsocket(int ver)
>  static void status_bar_update(void)
>  {
>  	if (total_packets % 10 == 0) {
> -		fprintf(stderr, ".");
> +		fputc(stderr, '.');

[ ... ]

> @@ -825,7 +825,7 @@ static int test_tpacket(int version, int type)
>  	unmap_ring(sock, &ring);
>  	close(sock);
>
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Both conversions reverse the arguments.

> diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
> --- a/tools/testing/selftests/net/txtimestamp.c
> +++ b/tools/testing/selftests/net/txtimestamp.c
> @@ -200,10 +200,10 @@ static void __print_timestamp(const char *name, struct timespec *cur,
>  		ts_delta = timespec_to_ns64(cur) - timespec_to_ns64(&ts_usr);
>  		fprintf(stderr, "  (USR +");
>  		__print_ts_delta_formatted(ts_delta);
> -		fprintf(stderr, ")");
> +		fputc(stderr, ')');
>  	}
>
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  }

[ ... ]

> @@ -254,7 +254,7 @@ static void print_timing_event(char *name, struct timing_event *te)
>  	__print_ts_delta_formatted(te->min);
>  	fprintf(stderr, ", max=");
>  	__print_ts_delta_formatted(te->max);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  }

[ ... ]

> @@ -271,7 +271,7 @@ static void print_payload(char *data, int len)
>  	fprintf(stderr, "payload: ");
>  	for (i = 0; i < len; i++)
>  		fprintf(stderr, "%02hhx ", data[i]);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  }

[ ... ]

> @@ -933,7 +933,7 @@ int main(int argc, char **argv)
>  	fprintf(stderr, "protocol:     %s\n", sock_names[cfg_proto]);
>  	fprintf(stderr, "payload:      %u\n", cfg_payload_len);
>  	fprintf(stderr, "server port:  %u\n", dest_port);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

All four conversions reverse the arguments.

> diff --git a/tools/testing/selftests/powerpc/nx-gzip/gunz_test.c b/tools/testing/selftests/powerpc/nx-gzip/gunz_test.c
> --- a/tools/testing/selftests/powerpc/nx-gzip/gunz_test.c
> +++ b/tools/testing/selftests/powerpc/nx-gzip/gunz_test.c
> @@ -363,7 +363,7 @@
>  			goto err3;
>  		fprintf(stderr, "%02x ", tmp[i]);
>  		if (i == 5)
> -			fprintf(stderr, "\n");
> +			fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
> --- a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
> @@ -10,7 +10,7 @@ #define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H
>
>  #define VFIO_LOG_AND_EXIT(...) do {		\
>  	fprintf(stderr, "  " __VA_ARGS__);	\
> -	fprintf(stderr, "\n");			\
> +	fputc(stderr, '\n');			\

Arguments reversed in a widely-used macro. Every expansion of this macro
is broken.

> diff --git a/tools/testing/selftests/vfio/lib/libvfio.c b/tools/testing/selftests/vfio/lib/libvfio.c
> --- a/tools/testing/selftests/vfio/lib/libvfio.c
> +++ b/tools/testing/selftests/vfio/lib/libvfio.c
> @@ -60,16 +60,16 @@ char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs)
>  	}
>
>  	fprintf(stderr, "Unable to determine which device(s) to use, skipping test.\n");
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  	fprintf(stderr, "To pass the device address via environment variable:\n");
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  	fprintf(stderr, "    export VFIO_SELFTESTS_BDF=\"segment:bus:device.function\"\n");
>  	fprintf(stderr, "    %s [options]\n", argv[0]);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  	fprintf(stderr, "To pass the device address(es) via argv:\n");
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');
>  	fprintf(stderr, "    %s [options] segment:bus:device.function ...\n", argv[0]);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

All five conversions reverse the arguments.

> diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/vsock_diag_test.c
> --- a/tools/testing/vsock/vsock_diag_test.c
> +++ b/tools/testing/vsock/vsock_diag_test.c
> @@ -86,7 +86,7 @@ static void print_vsock_addr(FILE *fp, unsigned int cid, unsigned int port)
>  		fprintf(fp, "%u:", cid);
>
>  	if (port == VMADDR_PORT_ANY)
> -		fprintf(fp, "*");
> +		fputc(fp, '*');

[ ... ]

> @@ -94,7 +94,7 @@ static void print_vsock_addr(FILE *fp, unsigned int cid, unsigned int port)
>  static void print_vsock_stat(FILE *fp, struct vsock_stat *st)
>  {
>  	print_vsock_addr(fp, st->msg.vdiag_src_cid, st->msg.vdiag_src_port);
> -	fprintf(fp, " ");
> +	fputc(fp, ' ');

Both conversions reverse the arguments.

> diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
> --- a/tools/thermal/tmon/sysfs.c
> +++ b/tools/thermal/tmon/sysfs.c
> @@ -522,7 +522,7 @@ int update_thermal_data()
>  	}
>
>  	if (tmon_log) {
> -		fprintf(tmon_log, "\n");
> +		fputc(tmon_log, '\n');

Arguments reversed.

> diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
> --- a/tools/thermal/tmon/tmon.c
> +++ b/tools/thermal/tmon/tmon.c
> @@ -199,7 +199,7 @@
>  		fprintf(tmon_log, "%s%d ", ptdata.cdi[i].type,
>  			ptdata.cdi[i].instance);
>
> -	fprintf(tmon_log, "\n");
> +	fputc(tmon_log, '\n');

Arguments reversed.

> diff --git a/tools/tracing/latency/latency-collector.c b/tools/tracing/latency/latency-collector.c
> --- a/tools/tracing/latency/latency-collector.c
> +++ b/tools/tracing/latency/latency-collector.c
> @@ -1999,7 +1999,7 @@
>  "been enabled. Random sleep is intended for the following tracers:\n");
>  			for (i = 0; random_tracers[i]; i++)
>  				fprintf(stderr, "%s\n", random_tracers[i]);
> -			fprintf(stderr, "\n");
> +			fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/tracing/rtla/src/common.c b/tools/tracing/rtla/src/common.c
> --- a/tools/tracing/rtla/src/common.c
> +++ b/tools/tracing/rtla/src/common.c
> @@ -449,7 +449,7 @@ void common_usage(const char *tool, const char *mode,
>  		fprintf(stderr, "%s [-h] ", mode);
>
>  	print_msg_array(start_msgs);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
> --- a/tools/tracing/rtla/src/utils.c
> +++ b/tools/tracing/rtla/src/utils.c
> @@ -67,7 +67,7 @@ void fatal(const char *fmt, ...)
>  	va_start(ap, fmt);
>  	vfprintf(stderr, fmt, ap);
>  	va_end(ap);
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
> --- a/tools/usb/ffs-test.c
> +++ b/tools/usb/ffs-test.c
> @@ -562,7 +562,7 @@ empty_out_buf(struct thread *ignore, const void *buf, size_t nbytes)
>  				fprintf(stderr, "%4zd:", len);
>  			fprintf(stderr, " %02x", *p);
>  			if (31 == (len % 32))
> -				fprintf(stderr, "\n");
> +				fputc(stderr, '\n');

Arguments reversed.

> diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
> --- a/tools/verification/rv/src/in_kernel.c
> +++ b/tools/verification/rv/src/in_kernel.c
> @@ -667,7 +667,7 @@ static void ikm_usage_print_reactors(void)
>  		end = strstr(start, "\n");
>  	}
>
> -	fprintf(stderr, "\n");
> +	fputc(stderr, '\n');

Arguments reversed.

Looking at the lore discussion by Andi Kleen and Steven Rostedt, they
raised a concern that GCC already performs this fprintf->fputc optimization
automatically, making the patch unnecessary code churn. The author has not
responded to this feedback.

Beyond the optimization question, the technical implementation has a
systematic bug: every fputc() conversion in this patch reverses the
argument order.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/30016526959
--===============8746857589958803762==--

