Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78E7CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 10:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08B66B0005; Tue, 19 May 2026 06:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8C06B0088; Tue, 19 May 2026 06:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5C16B008C; Tue, 19 May 2026 06:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEAD26B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:11:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C2B512027A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:11:51 +0000 (UTC)
X-FDA: 84783753222.17.05B4F06
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf17.hostedemail.com (Postfix) with ESMTP id AB22540006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:11:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DmkPwh4b;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779185509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzWJwvWxPpco8TzmmBNxmtFYeb/ClD+muX42vgevDLg=;
	b=EndVIvtOSZNNJJhwycdfNo8khBxspgCPkOfjCH8OqP/i1fqwB0gS5IlWvAIdoE0xeXNQt9
	0MpsJmHiZ+gtyNHfVvcL72gTrR6zHCzfrBf9R5oifbE5ndIATjPRVQHJ9ABGIhCzOntl4Q
	/euM+ecuARoh8xq35yuAtNdA44u1D88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779185509; a=rsa-sha256;
	cv=none;
	b=fCDC/H1A9c2sSjZ7ekEpzufg2/5QpCH3kFbJ0/4ANWutWUaq+kAO1YkvaJDzxEBDbDi2/u
	yG58Z2xOd2zhNv75rOI4fUypExhBMAyZtdTY5Nnc76lXvlwStaIxOh4kau828plxwILOci
	1YHFfHJMpKIrD15EsVcelo2p9HesP/Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DmkPwh4b;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779185508; x=1810721508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q51WE7wevZ2jWA3uAvc7h7Tfqyk1QPZnTjxADHrEy64=;
  b=DmkPwh4bUykJXI6TyJSRjTz+Cm1Fbh4m2AR1R3/pImaQ9UyPbCepQnH/
   qXHWF51ObM9r5dWLBYJsKFMwuAujDHfZluz3eiDw0olCBS6e4ym6zIBvY
   elsKf48qyn0F7eP9dP0nYgmevHO5MVBaPuac1Wlb5vSqYiO+PBwEB2gPN
   hbDLpP186ucN9GHGssQIodaWBf3KsDtE9rrom0dctD+L1kE3WR8x4lZch
   dIh37kFfBSLTPVzvwwuu7WFwiiTb5J4Vqd1eic91XzOMMkQM32nm8J+I2
   Yf4iHDeu25ivy0/+hR2F/GLEtAkCRmWpxrnosB2fs/ra+fYhRJ9CQ3bfj
   A==;
X-CSE-ConnectionGUID: KFYvlLQCSMSQKs0bpO4bwg==
X-CSE-MsgGUID: YHCOyV0eTJyBANRys4q00w==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="80037365"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="80037365"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 03:11:46 -0700
X-CSE-ConnectionGUID: 1kE+sZBsRj6v0jA3kbW9aw==
X-CSE-MsgGUID: J5RMBlqPSCSLUopRIysj7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="263508820"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 19 May 2026 03:11:42 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPHQ1-000000000rZ-40bx;
	Tue, 19 May 2026 10:11:28 +0000
Date: Tue, 19 May 2026 18:10:50 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
	bpf@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ian Rogers <irogers@google.com>, Jiri Olsa <olsajiri@gmail.com>,
	"Subject:[PATCH v2]" <tracing/pr@web.codeaurora.org>
Subject: Re: [PATCH v4] tracing/probes: Allow use of BTF names to dereference
 pointers
Message-ID: <202605191828.Y3E73pH1-lkp@intel.com>
References: <20260518232312.0c78f055@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518232312.0c78f055@gandalf.local.home>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB22540006
X-Rspam-User: 
X-Stat-Signature: qwgrcbupwqe1fgn48bf377cg5eb3dj9y
X-HE-Tag: 1779185507-906505
X-HE-Meta: U2FsdGVkX1/geGWlEkOEYsKyJWxTg+s8MHTDmmdxmr7RffE1Vd2+h/hoEoZuvQN9kQqPolB704jCff+sfErUo2EA53eu05633hAR5NqEimqRtwzsoOtOKglMbGooN3hwRTtYdBpebNqDcPjM9yptPFhRqAlTdOIhPzMDp1C7QUsIA9/kGJDtLPsL3GPfmY/x9XSi4RU045wgL5dZrMyNhpKjLLW23DBGk8WU1QNwuJUVPy8qgS7CHc7xQ5HCDjcXabjgBD8nhwne4hJtcjgp0HmWaupHFNsmlJNTbZl1HMDmLt6Siu8M7rXn1uISQUUZ1UfaT5K1+l4Jqo4HC+Tv1B26mR0Akz2vP0Mhb42cLzFnwsijzW9mpegi1ftm6LHWIpHRcPL3HK9yIPqV3rQWwyq0bQgznUOevd90QJ0NSQ+1uatPUTI+NfOyxe+R3uH0CUNcY17z2T3xk+DHQqwDIsq56hh3NRo70FnH+7NP6kCDQK9QCNof1mg2YMXkndKrjvoAdqj97EvzDq6oiPww3EKoVxRkiAuB0EnFOtXCr68jZo1QJTJOVyoQg4IH11vHu0uM7uWkgiHAP8M9D1O3cUeQRF+X+OoCHjA4c3NT2ipPRPqtTCIT91DQqehgR0G3MIyzyG+OIQIQDe5iTygK82N8Q/aJWOos/tCqx+34GJYUcH/EpqCRIjp98207bEJ53OA+KTQmgOAF0f/+LSXC7GEfYJam4fbspMIIkYSQn4wzYvjTXR1Jd94uqA70PG43dcZGLTV5q4tB5kQs5glhN+6XUoQ5z6Qqt2hbD/hdxvG1G0W9eFl6vmWe98cIb5aElP5SAgpxTqfI/sOuBB/KsHFAQZ2R4LqJ1M68jFB5gYSgB545c/rk6r44qmFUbf80gCbHfMmm0Z4E2Z6Dc+6WshVU8WbhuVaOGk3RAY4LEQg3FQxNlRVL3IX07Ej1q7NonUpbGFzEnH5VhqVKssN
 1EzYFxws
 906BNGL1j0+od7wFg/HVhB4eyi31ajtJVYbeHScmO4p3ViCNEvJwceSUaXUGQVT8hy8xyrqJHOyHKHYgJPofTaxvKsRzvqSypdHIPhF/mmtC0c110WAuq7+r62tCRsdvqXF9UgDd7OD3VEOVN7oQBAnGiv5jUPVA//xsVbwgxlEi9l5eju4XaaW+qpVsMBk+QqjakrejuVoLvkURPi7nuac1eUN4Ar6TmrYir4tZCIiUhEjz8y/oLLgxkN+p3rFTjzJJqZwVCrK/AqdzC72sJ0Zp/s6+8zJfj9DCW+hpoU6uDLqqZGlOQxZmRixDfeRYUoYuplINYQGVwWkozVN1P1vtpUTZZjx4M60Qm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[also build test ERROR on linus/master v7.1-rc4 next-20260518]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-probes-Allow-use-of-BTF-names-to-dereference-pointers/20260519-121930
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20260518232312.0c78f055%40gandalf.local.home
patch subject: [PATCH v4] tracing/probes: Allow use of BTF names to dereference pointers
config: sparc64-defconfig (https://download.01.org/0day-ci/archive/20260519/202605191828.Y3E73pH1-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260519/202605191828.Y3E73pH1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605191828.Y3E73pH1-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/trace/trace_probe.c:1289:9: error: call to undeclared function 'query_btf_struct'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1289 |                 ret = query_btf_struct(arg + 1, ctx);
         |                       ^
   1 error generated.


vim +/query_btf_struct +1289 kernel/trace/trace_probe.c

  1120	
  1121	/* Recursive argument parser */
  1122	static int
  1123	parse_probe_arg(char *arg, const struct fetch_type *type,
  1124			struct fetch_insn **pcode, struct fetch_insn *end,
  1125			struct traceprobe_parse_context *ctx)
  1126	{
  1127		struct fetch_insn *code = *pcode;
  1128		unsigned long param;
  1129		int deref = FETCH_OP_DEREF;
  1130		long offset = 0;
  1131		char *tmp;
  1132		int ret = 0;
  1133	
  1134		switch (arg[0]) {
  1135		case '$':
  1136			ret = parse_probe_vars(arg, type, pcode, end, ctx);
  1137			break;
  1138	
  1139		case '%':	/* named register */
  1140			if (ctx->flags & (TPARG_FL_TEVENT | TPARG_FL_FPROBE)) {
  1141				/* eprobe and fprobe do not handle registers */
  1142				trace_probe_log_err(ctx->offset, BAD_VAR);
  1143				break;
  1144			}
  1145			ret = regs_query_register_offset(arg + 1);
  1146			if (ret >= 0) {
  1147				code->op = FETCH_OP_REG;
  1148				code->param = (unsigned int)ret;
  1149				ret = 0;
  1150			} else
  1151				trace_probe_log_err(ctx->offset, BAD_REG_NAME);
  1152			break;
  1153	
  1154		case '@':	/* memory, file-offset or symbol */
  1155			if (isdigit(arg[1])) {
  1156				ret = kstrtoul(arg + 1, 0, &param);
  1157				if (ret) {
  1158					trace_probe_log_err(ctx->offset, BAD_MEM_ADDR);
  1159					break;
  1160				}
  1161				/* load address */
  1162				code->op = FETCH_OP_IMM;
  1163				code->immediate = param;
  1164			} else if (arg[1] == '+') {
  1165				/* kprobes don't support file offsets */
  1166				if (ctx->flags & TPARG_FL_KERNEL) {
  1167					trace_probe_log_err(ctx->offset, FILE_ON_KPROBE);
  1168					return -EINVAL;
  1169				}
  1170				ret = kstrtol(arg + 2, 0, &offset);
  1171				if (ret) {
  1172					trace_probe_log_err(ctx->offset, BAD_FILE_OFFS);
  1173					break;
  1174				}
  1175	
  1176				code->op = FETCH_OP_FOFFS;
  1177				code->immediate = (unsigned long)offset;  // imm64?
  1178			} else {
  1179				/* uprobes don't support symbols */
  1180				if (!(ctx->flags & TPARG_FL_KERNEL)) {
  1181					trace_probe_log_err(ctx->offset, SYM_ON_UPROBE);
  1182					return -EINVAL;
  1183				}
  1184				/* Preserve symbol for updating */
  1185				code->op = FETCH_NOP_SYMBOL;
  1186				code->data = kstrdup(arg + 1, GFP_KERNEL);
  1187				if (!code->data)
  1188					return -ENOMEM;
  1189				if (++code == end) {
  1190					trace_probe_log_err(ctx->offset, TOO_MANY_OPS);
  1191					return -EINVAL;
  1192				}
  1193				code->op = FETCH_OP_IMM;
  1194				code->immediate = 0;
  1195			}
  1196			/* These are fetching from memory */
  1197			if (++code == end) {
  1198				trace_probe_log_err(ctx->offset, TOO_MANY_OPS);
  1199				return -EINVAL;
  1200			}
  1201			*pcode = code;
  1202			code->op = FETCH_OP_DEREF;
  1203			code->offset = offset;
  1204			break;
  1205	
  1206		case '+':	/* deref memory */
  1207		case '-':
  1208			if (arg[1] == 'u') {
  1209				deref = FETCH_OP_UDEREF;
  1210				arg[1] = arg[0];
  1211				arg++;
  1212			}
  1213			if (arg[0] == '+')
  1214				arg++;	/* Skip '+', because kstrtol() rejects it. */
  1215			tmp = strchr(arg, '(');
  1216			if (!tmp) {
  1217				trace_probe_log_err(ctx->offset, DEREF_NEED_BRACE);
  1218				return -EINVAL;
  1219			}
  1220			*tmp = '\0';
  1221			ret = kstrtol(arg, 0, &offset);
  1222			if (ret) {
  1223				trace_probe_log_err(ctx->offset, BAD_DEREF_OFFS);
  1224				break;
  1225			}
  1226			ctx->offset += (tmp + 1 - arg) + (arg[0] != '-' ? 1 : 0);
  1227			arg = tmp + 1;
  1228			tmp = strrchr(arg, ')');
  1229			if (!tmp) {
  1230				trace_probe_log_err(ctx->offset + strlen(arg),
  1231						    DEREF_OPEN_BRACE);
  1232				return -EINVAL;
  1233			} else {
  1234				const struct fetch_type *t2 = find_fetch_type(NULL, ctx->flags);
  1235				int cur_offs = ctx->offset;
  1236	
  1237				*tmp = '\0';
  1238				ret = parse_probe_arg(arg, t2, &code, end, ctx);
  1239				if (ret)
  1240					break;
  1241				ctx->offset = cur_offs;
  1242				if (code->op == FETCH_OP_COMM ||
  1243				    code->op == FETCH_OP_DATA) {
  1244					trace_probe_log_err(ctx->offset, COMM_CANT_DEREF);
  1245					return -EINVAL;
  1246				}
  1247				if (++code == end) {
  1248					trace_probe_log_err(ctx->offset, TOO_MANY_OPS);
  1249					return -EINVAL;
  1250				}
  1251				*pcode = code;
  1252	
  1253				code->op = deref;
  1254				code->offset = offset;
  1255				/* Reset the last type if used */
  1256				ctx->last_type = NULL;
  1257			}
  1258			break;
  1259		case '\\':	/* Immediate value */
  1260			if (arg[1] == '"') {	/* Immediate string */
  1261				ret = __parse_imm_string(arg + 2, &tmp, ctx->offset + 2);
  1262				if (ret)
  1263					break;
  1264				code->op = FETCH_OP_DATA;
  1265				code->data = tmp;
  1266			} else {
  1267				ret = str_to_immediate(arg + 1, &code->immediate);
  1268				if (ret)
  1269					trace_probe_log_err(ctx->offset + 1, BAD_IMM);
  1270				else
  1271					code->op = FETCH_OP_IMM;
  1272			}
  1273			break;
  1274		case '(':
  1275			tmp = strrchr(arg, ')');
  1276			if (!tmp) {
  1277				trace_probe_log_err(ctx->offset + strlen(arg),
  1278						    DEREF_OPEN_BRACE);
  1279				return -EINVAL;
  1280			}
  1281	
  1282			tmp--;
  1283			if (*tmp != '*') {
  1284				trace_probe_log_err(ctx->offset + (tmp - arg),
  1285						    NO_PTR_STRCT);
  1286				return -EINVAL;
  1287			}
  1288			*tmp = '\0';
> 1289			ret = query_btf_struct(arg + 1, ctx);
  1290			*tmp = '*';
  1291	
  1292			if (ret < 0) {
  1293				trace_probe_log_err(ctx->offset + 1, NO_PTR_STRCT);
  1294				return -EINVAL;
  1295			}
  1296	
  1297			ctx->flags |= TPARG_FL_STRUCT;
  1298			tmp += 2;
  1299	
  1300			if (*tmp != '$') {
  1301				trace_probe_log_err(ctx->offset + (tmp - arg),
  1302						    BAD_VAR);
  1303				return -EINVAL;
  1304			}
  1305	
  1306			ctx->offset += tmp - arg;
  1307			ret = parse_probe_vars(tmp, type, pcode, end, ctx);
  1308			ctx->flags &= ~TPARG_FL_STRUCT;
  1309			ctx->last_struct = NULL;
  1310			break;
  1311		default:
  1312			if (isalpha(arg[0]) || arg[0] == '_') {	/* BTF variable */
  1313				if (!tparg_is_function_entry(ctx->flags) &&
  1314				    !tparg_is_function_return(ctx->flags)) {
  1315					trace_probe_log_err(ctx->offset, NOSUP_BTFARG);
  1316					return -EINVAL;
  1317				}
  1318				ret = parse_btf_arg(arg, pcode, end, ctx);
  1319				break;
  1320			}
  1321		}
  1322		if (!ret && code->op == FETCH_OP_NOP) {
  1323			/* Parsed, but do not find fetch method */
  1324			trace_probe_log_err(ctx->offset, BAD_FETCH_ARG);
  1325			ret = -EINVAL;
  1326		}
  1327		return ret;
  1328	}
  1329	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

