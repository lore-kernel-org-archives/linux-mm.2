Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C603C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDF76B008A; Wed,  9 Sep 2026 17:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681836B008C; Wed,  9 Sep 2026 17:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522466B0092; Wed,  9 Sep 2026 17:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1BBA6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:29:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BD5A140353
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:29:14 +0000 (UTC)
X-FDA: 85195514628.20.45D7566
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf19.hostedemail.com (Postfix) with ESMTP id ECDB31A0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:29:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sd4OYxwI;
	spf=pass (imf19.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788989346;
	b=0e9XqIOFI9UNwzR9U8wQpcUbPUR1O3Q087P2OKH25AG44hC9G8zibdFYI8wm31NDjW1Wlj
	FVl9K6eKz1Mo4LKWkYGCCYA9khvwm9N9fq86XGy0H4SP/D97ZXzvQCyD5e+xNgjcvSqTQp
	EfFMvH2mXBtBftdH0J8h4sjBcNbtqU8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sd4OYxwI;
	spf=pass (imf19.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788989346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoohD3gHrISFOhTVTqtONMb893/Pksx1NkDrUFxXD64=;
	b=SGUJzHrhOLZ3CenDNX7SWOKKo4fq2vksHY012K9YHggleCc34Jas2IZG7kIbfu7aMoyrrY
	hDWTOvVpPD31fvlFja+HqGnKFLIWpN2iButlr9v+SXtqz3nKA+pSy0NzRNPPk8yE5wNo5p
	2SDssOE3pYzfjDZ1R5kL1Jz6F1Y4M28=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EuIEFdx+emdg3TG0zuIZTZ91zfsrefs7iKI0BMCdjEA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788989339; v=1; x=1789594139;
 b=Sd4OYxwIdOydkPgCbRWnaSnS8DtXuZnszi+vqCHD3rQoqGu4UiZUHAFxLuwj4LnkwI7vDn5v
 fdIdN5LIXEpPnrAj3XsEuijwD3sCAsguzt9vjx0omWJ8w9pWCH8IN2kroTdBPOUrb12jHz//EAO
 NCOCmI9wk/UJ4TRlC307Uwh0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7b9d9962d3a6e03d;
	Wed, 09 Sep 2026 21:28:59 +0000
X-Mizu-Trace-ID: 7b9d9962d3a6e03d
X-Migadu-Flow: FLOW_OUT
Message-ID: <4032946b-62e0-42df-9147-f59b36f20d82@linux.dev>
Date: Wed, 9 Sep 2026 14:28:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v9 2/2] selftests/bpf: Add memcg async reclaim
 test
To: Hui Zhu <hui.zhu@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1788857915.git.zhuhui@kylinos.cn>
 <8bb6a02901de019b238017640bc62b100aaf7c1d.1788857915.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <8bb6a02901de019b238017640bc62b100aaf7c1d.1788857915.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECDB31A0004
X-Stat-Signature: 3gpf94rok6zfu6orksqkjyedif3dfjmw
X-HE-Tag: 1788989345-52521
X-HE-Meta: U2FsdGVkX1+MtaqyxCw5Wkat0c971+FBFwsDnBnux0+NYzE69jLIMCb3eWNEUIkKEX+xax0VYIeHE2UJz6X1y2gymOxTciNaRmqPQdx1mTZtZG0R7j+x7PqQ17pD62wwhiWzXl3KLGiQzEzOZ0TaE+gUtMIEpTR/MF3enei2RFugTVKj9Y+ltPrUTRZaF+G67MTGqRx/Mo1r9duYE0gmTXYMsaRwkn0zZDEBvPOePpjfJf/8nxm2DcNel2pM4khV0nMDBscl1KODOu2GtgfKJj766hSV4OklVZ2ijIrs/jBKQGgFWbZJ+HtRcWOBY1xvUSg4wcxkN/66MSbjIHWzm1rFncLJ8m4inQAq6qBeJ772/IgPdZBUOxWbbBYSaHovvVlRU/hdp9pVwXa4tlLMKusG1Kqn0ST+lSzYjH2Mhbp5P5fCJvkVhz4esOXLLbhp//pPDjgCfYltqw8FatJRkTGyVIt5T5CD6QPBr22mv+4KJAV3drAEmdPve5JH4PzOj3nX1DwZCaC+yns/DH65mRpQqOaDNtFLYUD8bicwH1V9ugOSEeJ1H/Uq/KwudN20QFP+FCOtRnaNu4rhGMpjR9SQ3ZSoQlSR/f47Rd3dziMtJeiiOyGWp3WA5NmGy1F8bH/S34xbaHGXCPCyCktsMh+jKK36Q3+wRmqlF51/Qggn4kI+AdACWIWGgG2UdjgpAFfSmhXJrsOlfmXhTGO3D39vFD18l6i5OQL3SOgHEbKojDltbTfzpfV40vtV1FlNVTbUSTv/KQNNwRicYsUGPbniW7Ko/XXalqFZYEiKWbT5OGH9XiMrCBEHanY6KQDWhYnAIK+FnbowbaFdk3x5RCyzMniOaODaCTmJKdDhLpyT/mR3VBVIqkJxZEZB1sPZh3KHLhGljOIwsVsVeM3770W+wZvurflvysnqKPNjVPzQhz+wr7VdUbdvEM4FYzfRxNz4L68M/nvodEHUAMi
 G+7fI37F
 qXmoNaaIyLrkJRoTD0SWd2E5cMWT/IYHIs3+nFpN6/ygOvyR1MQFE5rMcPUKoz8Ue5HhhehLCSf7D+eUtsuXj4mYEXcQUGXzjf27E3+nwK+FEiltyYjsOnKSe6XDt6dsfQPlJpY59nz455ZGNI+f+qObwqtlRskOJXNRK4UWPmMNaYvQFyD4i4NjyhJrld2GNm3ZS8P77NsrTHRAcn2b4khaxkra8xG2caKZbAkGYd5brvx9g6WHjYDY9aB/0+HD8LEX8/Tjz/3JvfSSDvFAHrCC2L0JjLOQ4f5e0/ecC65AkpJuakzR1j+XbA7UN0C/FWrnXnpV4NuWg0mky1a62BB5aY4akORocZo0vRQPwMXOGgs3XOudNLjHU0kxpd6rdZ51QbfmmBLomtiYV8tXMyU3Btg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 2:11 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add the memcg_async_reclaim selftest, which verifies that BPF-driven
> async proactive reclaim mitigates refault-induced slowdown under
> memory pressure: a BPF program monitors the refault stats of a
> memory-pressured cgroup and, once they grow, asynchronously reclaims
> another cgroup via bpf_wq and bpf_proactive_reclaim(), letting the
> pressured workload finish faster.

Do you have stats on this? It would be good to include in the cover
letter if so.

> 
> The BPF program also handles a dying reclaim target. Looking the
> target up by id is not enough: bpf_cgroup_from_id() keeps handing
> back a cgroup until its last reference is dropped, so the program
> checks the css flags and skips reclaim once the target is offlined
> or dying. A second test, memcg_async_reclaim_dying, keeps reclaim
> rounds running against the target, removes the target cgroup while
> reclaim is in flight, and verifies that reclaim stops on the removed
> target instead of reclaiming from it.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   .../bpf/prog_tests/memcg_async_reclaim.c      | 686 ++++++++++++++++++
>   .../selftests/bpf/progs/memcg_async_reclaim.c | 259 +++++++
>   2 files changed, 945 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
>   create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> new file mode 100644
> index 000000000000..65f500684463
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
> @@ -0,0 +1,686 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Memory controller eBPF async reclaim test
> + */
> +
> +#include <test_progs.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/vfs.h>
> +#include <sys/wait.h>
> +#include <fcntl.h>
> +#include <signal.h>
> +#include <time.h>
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <limits.h>
> +#include <linux/magic.h>
> +
> +#include "cgroup_helpers.h"
> +
> +struct bpf_args {
> +	u64 high_cgroup_id;
> +	u64 low_cgroup_id;
> +	u64 event_delta_threshold;
> +	u64 check_ns;
> +};
> +
> +#include "memcg_async_reclaim.skel.h"
> +
> +#define FILE_SIZE (32 * 1024 * 1024ul)
> +#define BUFFER_SIZE (4096)
> +#define CG_LIMIT (32 * 1024 * 1024ul)
> +#define READ_TIMES 50
> +
> +#define CG_DIR "/memcg_async_reclaim"
> +#define CG_HIGH_DIR CG_DIR "/high"
> +#define CG_LOW_DIR CG_DIR "/low"
> +
> +#define CG_DYING_DIR "/memcg_async_reclaim_dying"
> +#define CG_DYING_TRIGGER_DIR CG_DYING_DIR "/trigger"
> +#define CG_DYING_TARGET_DIR CG_DYING_DIR "/target"
> +
> +#define CHECK_PERIOD_NS (2 * 1000 * 1000ull)
> +#define EVENT_DELTA_THRESHOLD 1
> +
> +/*
> + * Timing for the dying test: after the target cgroup is removed, give
> + * in-flight reclaim passes time to drain, then wait for a reclaim round
> + * to hit the removed target. The keepalive reader keeps the trigger
> + * cgroup refaulting, and the timer fires every CHECK_PERIOD_NS, so
> + * such a round must show up within a few timer periods.
> + */
> +#define DYING_SETTLE_US (200 * 1000)
> +#define DYING_POLL_ITERS 500
> +#define DYING_POLL_INTERVAL_US (10 * 1000)
> +
> +/*
> + * The workload files must sit on a regular filesystem: with swap
> + * disabled for the cgroup, tmpfs/ramfs pages are unevictable and would
> + * OOM the cgroup instead of exercising reclaim; they are also charged
> + * as anonymous memory, so they never raise the WORKINGSET_REFAULT_FILE
> + * events the BPF program monitors. Fall back to the current directory
> + * when /tmp is backed by such a filesystem.
> + */
> +static const char *workload_files_dir(void)
> +{
> +	struct statfs st;
> +
> +	if (!statfs("/tmp", &st) &&
> +	    (st.f_type == TMPFS_MAGIC || st.f_type == RAMFS_MAGIC))
> +		return ".";
> +	return "/tmp";
> +}
> +
> +/*
> + * The workload children run after test_progs hijacked stdio, so
> + * anything they print is lost with their private copy of the hijacked
> + * buffer. The exit status is the only diagnostics channel that reaches
> + * the parent, so each failing step gets its own code.
> + */
> +enum child_exit_code {
> +	CHILD_EXIT_OK = 0,
> +	CHILD_EXIT_JOIN_CGROUP,
> +	CHILD_EXIT_WRITE_FILE,
> +	CHILD_EXIT_READ_FILE,
> +	CHILD_EXIT_TIME_FILE,
> +};
> +
> +static const char *child_exit_str(int code)
> +{
> +	switch (code) {
> +	case CHILD_EXIT_OK:
> +		return "success";
> +	case CHILD_EXIT_JOIN_CGROUP:
> +		return "join cgroup";
> +	case CHILD_EXIT_WRITE_FILE:
> +		return "write data file";
> +	case CHILD_EXIT_READ_FILE:
> +		return "read data file";
> +	case CHILD_EXIT_TIME_FILE:
> +		return "write time file";
> +	default:
> +		return "unknown";
> +	}
> +}
> +
> +static int setup_high_low_cgroups(u64 *high_cgroup_id, u64 *low_cgroup_id)
> +{
> +	int ret;
> +	char limit_buf[20];
> +
> +	ret = setup_cgroup_environment();
> +	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
> +		goto cleanup;
> +
> +	ret = create_and_get_cgroup(CG_DIR);
> +	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DIR))
> +		goto cleanup;
> +	close(ret);
> +
> +	ret = enable_controllers(CG_DIR, "memory");
> +	if (!ASSERT_OK(ret, "enable_controllers"))
> +		goto cleanup;
> +
> +	snprintf(limit_buf, sizeof(limit_buf), "%lu", CG_LIMIT);
> +	ret = write_cgroup_file(CG_DIR, "memory.max", limit_buf);
> +	if (!ASSERT_OK(ret, "write_cgroup_file memory.max"))
> +		goto cleanup;
> +
> +	/*
> +	 * Keep the workloads from swapping out. With CONFIG_SWAP=n the
> +	 * memory.swap.max file does not exist, and no swap can happen
> +	 * anyway, so skip the write.
> +	 */
> +	if (!access("/proc/swaps", F_OK)) {
> +		ret = write_cgroup_file(CG_DIR, "memory.swap.max", "0");
> +		if (!ASSERT_OK(ret, "write_cgroup_file memory.swap.max"))
> +			goto cleanup;
> +	}
> +
> +	ret = create_and_get_cgroup(CG_HIGH_DIR);
> +	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_HIGH_DIR))
> +		goto cleanup;
> +	close(ret);
> +
> +	*high_cgroup_id = get_cgroup_id(CG_HIGH_DIR);
> +	if (!ASSERT_GT(*high_cgroup_id, 0, "get_cgroup_id"))
> +		goto cleanup;
> +
> +	ret = create_and_get_cgroup(CG_LOW_DIR);
> +	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_LOW_DIR))
> +		goto cleanup;
> +	close(ret);
> +
> +	*low_cgroup_id = get_cgroup_id(CG_LOW_DIR);
> +	if (!ASSERT_GT(*low_cgroup_id, 0, "get_cgroup_id"))
> +		goto cleanup;
> +
> +	return 0;
> +
> +cleanup:
> +	cleanup_cgroup_environment();
> +	return -1;
> +}
> +
> +/*
> + * The dying test needs an empty reclaim target plus a cgroup that keeps
> + * refaulting while the target is removed, so reclaim rounds keep
> + * starting and run into the removed target. The two have to be separate
> + * cgroups: the target must hold no processes to be removed, and v2's
> + * no-internal-process constraint keeps the refaulting workload out of
> + * any parent that has domain children.
> + */
> +static int setup_dying_cgroups(u64 *trigger_cgroup_id, u64 *target_cgroup_id)
> +{
> +	int ret;
> +	char limit_buf[20];
> +
> +	ret = setup_cgroup_environment();
> +	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
> +		goto cleanup;
> +
> +	ret = create_and_get_cgroup(CG_DYING_DIR);
> +	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DYING_DIR))
> +		goto cleanup;
> +	close(ret);
> +
> +	ret = enable_controllers(CG_DYING_DIR, "memory");
> +	if (!ASSERT_OK(ret, "enable_controllers"))
> +		goto cleanup;
> +
> +	snprintf(limit_buf, sizeof(limit_buf), "%lu", CG_LIMIT);
> +	ret = write_cgroup_file(CG_DYING_DIR, "memory.max", limit_buf);
> +	if (!ASSERT_OK(ret, "write_cgroup_file memory.max"))
> +		goto cleanup;
> +
> +	/* See the matching write in setup_high_low_cgroups(). */
> +	if (!access("/proc/swaps", F_OK)) {
> +		ret = write_cgroup_file(CG_DYING_DIR, "memory.swap.max", "0");
> +		if (!ASSERT_OK(ret, "write_cgroup_file memory.swap.max"))
> +			goto cleanup;
> +	}
> +
> +	ret = create_and_get_cgroup(CG_DYING_TRIGGER_DIR);
> +	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DYING_TRIGGER_DIR))
> +		goto cleanup;
> +	close(ret);
> +
> +	*trigger_cgroup_id = get_cgroup_id(CG_DYING_TRIGGER_DIR);
> +	if (!ASSERT_GT(*trigger_cgroup_id, 0, "get_cgroup_id"))
> +		goto cleanup;
> +
> +	ret = create_and_get_cgroup(CG_DYING_TARGET_DIR);
> +	if (!ASSERT_GE(ret, 0, "create_and_get_cgroup " CG_DYING_TARGET_DIR))
> +		goto cleanup;
> +	close(ret);
> +
> +	*target_cgroup_id = get_cgroup_id(CG_DYING_TARGET_DIR);
> +	if (!ASSERT_GT(*target_cgroup_id, 0, "get_cgroup_id"))
> +		goto cleanup;
> +
> +	return 0;
> +
> +cleanup:
> +	cleanup_cgroup_environment();
> +	return -1;
> +}
> +
> +static int write_file(const char *filename)
> +{
> +	int ret = -1;
> +	size_t written = 0;
> +	char *buffer;
> +	FILE *fp;
> +
> +	fp = fopen(filename, "wb");
> +	if (!fp)
> +		goto out;
> +
> +	buffer = malloc(BUFFER_SIZE);
> +	if (!buffer)
> +		goto cleanup_fp;
> +
> +	memset(buffer, 'A', BUFFER_SIZE);
> +
> +	while (written < FILE_SIZE) {
> +		size_t to_write = FILE_SIZE - written < BUFFER_SIZE ?
> +				  FILE_SIZE - written : BUFFER_SIZE;
> +
> +		if (fwrite(buffer, 1, to_write, fp) != to_write)
> +			goto cleanup;
> +		written += to_write;
> +	}
> +
> +	ret = 0;
> +cleanup:
> +	free(buffer);
> +cleanup_fp:
> +	fclose(fp);
> +out:
> +	return ret;
> +}
> +
> +static int read_file(const char *filename, int iterations)
> +{
> +	int ret = -1;
> +	long page_size = sysconf(_SC_PAGESIZE);
> +	char *map;
> +	size_t i;
> +	int fd;
> +	struct stat sb;
> +
> +	fd = open(filename, O_RDONLY);
> +	if (fd == -1)
> +		goto out;
> +
> +	if (fstat(fd, &sb) == -1)
> +		goto cleanup_fd;
> +
> +	if (sb.st_size != FILE_SIZE) {
> +		fprintf(stderr, "File size mismatch: expected %lu, got %lu\n",
> +			(unsigned long)FILE_SIZE, (unsigned long)sb.st_size);
> +		goto cleanup_fd;
> +	}
> +
> +	map = mmap(NULL, FILE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
> +	if (map == MAP_FAILED)
> +		goto cleanup_fd;
> +
> +	for (int iter = 0; iter < iterations; iter++) {
> +		for (i = 0; i < FILE_SIZE; i += page_size) {
> +			/* access a byte to trigger page fault */
> +			volatile char v = map[i];
> +			(void)v;
> +		}
> +	}
> +
> +	if (munmap(map, FILE_SIZE) == -1)
> +		goto cleanup_fd;
> +
> +	ret = 0;
> +
> +cleanup_fd:
> +	close(fd);
> +out:
> +	return ret;
> +}
> +
> +static int real_test_child_work(const char *cgroup_path, char *data_filename,
> +				char *time_filename, int read_times)
> +{
> +	struct timespec start, end;
> +	double elapsed;
> +	FILE *fp;
> +
> +	if (join_parent_cgroup(cgroup_path))
> +		return CHILD_EXIT_JOIN_CGROUP;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &start);
> +
> +	if (write_file(data_filename))
> +		return CHILD_EXIT_WRITE_FILE;
> +
> +	if (read_file(data_filename, read_times))
> +		return CHILD_EXIT_READ_FILE;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &end);
> +
> +	if (!time_filename)
> +		return CHILD_EXIT_OK;
> +
> +	elapsed = (end.tv_sec - start.tv_sec) +
> +		  (end.tv_nsec - start.tv_nsec) / 1000000000.0;
> +	printf("%.6f\n", elapsed);

Is this a leftover from debugging?

> +
> +	fp = fopen(time_filename, "w");
> +	if (!fp)
> +		return CHILD_EXIT_TIME_FILE;
> +	fprintf(fp, "%.6f", elapsed);
> +	fclose(fp);
> +
> +	return CHILD_EXIT_OK;
> +}
> +
> +static int get_time(char *time_filename, double *time)
> +{
> +	int ret = -1;
> +	FILE *fp;
> +	char buf[64];
> +
> +	fp = fopen(time_filename, "r");
> +	if (!ASSERT_OK_PTR(fp, "fopen"))
> +		goto out;
> +
> +	if (!ASSERT_OK_PTR(fgets(buf, sizeof(buf), fp), "fgets"))
> +		goto cleanup;
> +
> +	if (sscanf(buf, "%lf", time) != 1) {
> +		PRINT_FAIL("sscanf %s", buf);
> +		goto cleanup;
> +	}
> +
> +	ret = 0;
> +cleanup:
> +	fclose(fp);
> +out:
> +	return ret;
> +}
> +
> +static int
> +run_high_low_workload(double *high_elapsed, double *low_elapsed, int read_times)
> +{
> +	char high_data_file[PATH_MAX];
> +	char low_data_file[PATH_MAX];
> +	char high_time_file[PATH_MAX];
> +	char low_time_file[PATH_MAX];
> +	const char *dir = workload_files_dir();
> +	pid_t high_pid = -1, low_pid = -1;
> +	pid_t wait_ret;
> +	int fd, status;
> +	int ret = -1;
> +
> +	snprintf(high_data_file, sizeof(high_data_file),
> +		 "%s/memcg_async_high_data_XXXXXX", dir);
> +	snprintf(low_data_file, sizeof(low_data_file),
> +		 "%s/memcg_async_low_data_XXXXXX", dir);
> +	snprintf(high_time_file, sizeof(high_time_file),
> +		 "%s/memcg_async_high_time_XXXXXX", dir);
> +	snprintf(low_time_file, sizeof(low_time_file),
> +		 "%s/memcg_async_low_time_XXXXXX", dir);
> +
> +	fd = mkstemp(high_data_file);
> +	if (!ASSERT_GE(fd, 0, "mkstemp"))
> +		goto cleanup;
> +	close(fd);
> +
> +	fd = mkstemp(low_data_file);
> +	if (!ASSERT_GE(fd, 0, "mkstemp"))
> +		goto cleanup;
> +	close(fd);
> +
> +	fd = mkstemp(high_time_file);
> +	if (!ASSERT_GE(fd, 0, "mkstemp"))
> +		goto cleanup;
> +	close(fd);
> +
> +	fd = mkstemp(low_time_file);
> +	if (!ASSERT_GE(fd, 0, "mkstemp"))
> +		goto cleanup;
> +	close(fd);
> +
> +	low_pid = fork();
> +	if (!ASSERT_GE(low_pid, 0, "fork low"))
> +		goto cleanup;
> +	if (low_pid == 0)
> +		_exit(real_test_child_work(CG_LOW_DIR, low_data_file,
> +					  low_time_file, read_times));
> +
> +	high_pid = fork();
> +	if (!ASSERT_GE(high_pid, 0, "fork high"))
> +		goto cleanup;
> +	if (high_pid == 0)
> +		_exit(real_test_child_work(CG_HIGH_DIR, high_data_file,
> +					  high_time_file, read_times));
> +
> +	wait_ret = waitpid(low_pid, &status, 0);
> +	if (!ASSERT_GT(wait_ret, 0, "low waitpid"))
> +		goto cleanup;
> +	/*
> +	 * The child has been reaped and its PID can already be reused,
> +	 * so mark it to keep cleanup from signaling an unrelated process.
> +	 */
> +	low_pid = -1;
> +	if (!ASSERT_TRUE(WIFEXITED(status), "low exited"))
> +		goto cleanup;
> +	if (WEXITSTATUS(status) != CHILD_EXIT_OK) {
> +		PRINT_FAIL("low child failed at: %s (exit status %d)",
> +			   child_exit_str(WEXITSTATUS(status)),
> +			   WEXITSTATUS(status));
> +		goto cleanup;
> +	}
> +
> +	wait_ret = waitpid(high_pid, &status, 0);
> +	if (!ASSERT_GT(wait_ret, 0, "high waitpid"))
> +		goto cleanup;
> +	/* Same as above: the reaped PID must not be signaled again. */
> +	high_pid = -1;
> +	if (!ASSERT_TRUE(WIFEXITED(status), "high exited"))
> +		goto cleanup;
> +	if (WEXITSTATUS(status) != CHILD_EXIT_OK) {
> +		PRINT_FAIL("high child failed at: %s (exit status %d)",
> +			   child_exit_str(WEXITSTATUS(status)),
> +			   WEXITSTATUS(status));
> +		goto cleanup;
> +	}
> +
> +	if (get_time(high_time_file, high_elapsed))
> +		goto cleanup;
> +	if (get_time(low_time_file, low_elapsed))
> +		goto cleanup;
> +
> +	ret = 0;
> +
> +cleanup:
> +	/* On failure, make sure no child process is left behind */
> +	if (ret) {
> +		if (high_pid > 0) {
> +			kill(high_pid, SIGKILL);
> +			(void)waitpid(high_pid, NULL, 0);
> +		}
> +		if (low_pid > 0) {
> +			kill(low_pid, SIGKILL);
> +			(void)waitpid(low_pid, NULL, 0);
> +		}
> +	}
> +	unlink(low_time_file);
> +	unlink(high_time_file);
> +	unlink(low_data_file);
> +	unlink(high_data_file);
> +	return ret;
> +}
> +
> +static int
> +setup_bpf(u64 high_cgroup_id, u64 low_cgroup_id,
> +	  struct memcg_async_reclaim **skel_ptr)
> +{
> +	struct memcg_async_reclaim *skel;
> +	struct bpf_args args = {
> +		.high_cgroup_id = high_cgroup_id,
> +		.low_cgroup_id = low_cgroup_id,
> +		.event_delta_threshold = EVENT_DELTA_THRESHOLD,
> +		.check_ns = CHECK_PERIOD_NS,
> +	};
> +	LIBBPF_OPTS(bpf_test_run_opts, run_opts,
> +		.ctx_in = &args,
> +		.ctx_size_in = sizeof(args));
> +	int prog_init_fd, err;
> +
> +	skel = memcg_async_reclaim__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "memcg_async_reclaim__open_and_load"))
> +		return -1;
> +
> +	prog_init_fd = bpf_program__fd(skel->progs.wq_prog_init);
> +
> +	err = bpf_prog_test_run_opts(prog_init_fd, &run_opts);
> +	if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
> +		goto error_out;
> +	if (!ASSERT_EQ(run_opts.retval, 0, "prog_init retval"))
> +		goto error_out;
> +
> +	*skel_ptr = skel;
> +	return 0;
> +
> +error_out:
> +	memcg_async_reclaim__destroy(skel);
> +	return -1;
> +}
> +
> +void test_memcg_async_reclaim(void)
> +{
> +	u64 high_cgroup_id, low_cgroup_id;
> +	int err;
> +	double high_time = 0.0, low_time = 0.0;
> +	struct memcg_async_reclaim *skel = NULL;
> +
> +	err = setup_high_low_cgroups(&high_cgroup_id, &low_cgroup_id);
> +	if (!ASSERT_OK(err, "setup_high_low_cgroups reclaim"))
> +		return;
> +
> +	err = setup_bpf(high_cgroup_id, low_cgroup_id, &skel);
> +	if (!ASSERT_OK(err, "setup_bpf"))
> +		goto out;
> +
> +	err = run_high_low_workload(&high_time, &low_time, READ_TIMES);
> +	if (!ASSERT_OK(err, "run_high_low_workload reclaim"))
> +		goto out;
> +
> +	/*
> +	 * The timing comparison below alone cannot distinguish a working
> +	 * reclaim from a no-op one, so require that the BPF program
> +	 * actually reclaimed memory from the low cgroup.
> +	 */
> +	if (!ASSERT_GT(skel->bss->reclaim_calls, 0, "reclaim_calls"))
> +		goto out;
> +	if (!ASSERT_GT(skel->bss->reclaimed_bytes, 0, "reclaimed_bytes"))
> +		goto out;
> +
> +	if (high_time >= low_time)
> +		PRINT_FAIL("high cgroup not improved: high=%f low=%f",
> +			   high_time, low_time);

This is more of a benchmark, and may not be reliable for the CI. You
already proved reclaim worked above. Maybe just log the message without
failing the test.

> +
> +out:
> +	if (skel)
> +		memcg_async_reclaim__destroy(skel);
> +	cleanup_cgroup_environment();
> +}
> +
> +/*
> + * Keep refaults flowing through the trigger cgroup so reclaim rounds
> + * keep being triggered while the target cgroup is being removed. The
> + * child joins the trigger cgroup and writes the data file there, so
> + * that the file pages are charged to the trigger cgroup and actually
> + * come under its memory limit; then it re-reads the file in a loop
> + * until it is killed.
> + */
> +static pid_t spawn_keepalive_reader(const char *data_file)
> +{
> +	pid_t pid = fork();
> +
> +	if (pid != 0)
> +		return pid;
> +
> +	if (join_parent_cgroup(CG_DYING_TRIGGER_DIR))
> +		_exit(CHILD_EXIT_JOIN_CGROUP);
> +	if (write_file(data_file))
> +		_exit(CHILD_EXIT_WRITE_FILE);
> +	for (;;) {
> +		if (read_file(data_file, READ_TIMES))
> +			_exit(CHILD_EXIT_READ_FILE);
> +	}
> +}
> +
> +/*
> + * Remove the reclaim target while the BPF program keeps running and
> + * verify that reclaim stops on the dying/removed cgroup instead of
> + * reclaiming from it.
> + *
> + * The target stays empty; the workload lives in the trigger cgroup and
> + * only keeps refaults flowing so that reclaim rounds keep starting,
> + * both before and after the target is removed. reclaim_calls growing
> + * while the target is alive proves that rounds really run (the kfunc
> + * returns 0 on the empty target, but the call is still counted), and
> + * after the removal the skip counters must grow while reclaim_calls
> + * and reclaimed_bytes stay frozen.
> + */
> +void test_memcg_async_reclaim_dying(void)
> +{
> +	u64 trigger_cgroup_id, target_cgroup_id;
> +	u64 calls_before, bytes_before;
> +	char data_file[PATH_MAX] = "";
> +	struct memcg_async_reclaim *skel = NULL;
> +	pid_t reader_pid = -1;
> +	int err, fd, i;
> +
> +	err = setup_dying_cgroups(&trigger_cgroup_id, &target_cgroup_id);
> +	if (!ASSERT_OK(err, "setup_dying_cgroups"))
> +		return;
> +
> +	err = setup_bpf(trigger_cgroup_id, target_cgroup_id, &skel);
> +	if (!ASSERT_OK(err, "setup_bpf"))
> +		goto out;
> +
> +	snprintf(data_file, sizeof(data_file),
> +		 "%s/memcg_async_dying_XXXXXX", workload_files_dir());
> +	fd = mkstemp(data_file);
> +	if (!ASSERT_GE(fd, 0, "mkstemp"))
> +		goto out;
> +	close(fd);
> +
> +	reader_pid = spawn_keepalive_reader(data_file);
> +	if (!ASSERT_GT(reader_pid, 0, "fork keepalive reader"))
> +		goto out;
> +
> +	/* Wait for reclaim rounds to reach the live target cgroup. */
> +	for (i = 0; i < DYING_POLL_ITERS; i++) {
> +		if (skel->bss->reclaim_calls > 0)
> +			break;
> +		usleep(DYING_POLL_INTERVAL_US);
> +	}
> +	if (!ASSERT_GT(skel->bss->reclaim_calls, 0, "reclaim_calls"))
> +		goto out;
> +
> +	remove_cgroup(CG_DYING_TARGET_DIR);
> +
> +	/* Let reclaim passes that were already in flight drain. */
> +	usleep(DYING_SETTLE_US);
> +
> +	calls_before = skel->bss->reclaim_calls;
> +	bytes_before = skel->bss->reclaimed_bytes;
> +
> +	/* Wait for reclaim rounds to hit the removed cgroup. */
> +	for (i = 0; i < DYING_POLL_ITERS; i++) {
> +		if (skel->bss->reclaim_target_gone ||
> +		    skel->bss->reclaim_skipped_dying)
> +			break;
> +		usleep(DYING_POLL_INTERVAL_US);
> +	}

Instead of this recurring sleep-poll pattern, I think a ringbuf would be
a better fit. If you emitted a reclaim outcome each pass, you could take
an event-driven approach with timeouts.

> +
> +	if (!skel->bss->reclaim_target_gone &&
> +	    !skel->bss->reclaim_skipped_dying) {
> +		PRINT_FAIL("no reclaim round hit the removed cgroup (gone=%llu, dying=%llu)",
> +			   (unsigned long long)skel->bss->reclaim_target_gone,
> +			   (unsigned long long)skel->bss->reclaim_skipped_dying);
> +		goto out;
> +	}
> +
> +	/*
> +	 * reclaim_skipped_dying shows that the CSS_DYING/CSS_ONLINE check
> +	 * caught the cgroup mid-teardown. Whether it is hit is timing
> +	 * dependent, because the cgroup may already be fully released, so
> +	 * only the combined skip count above is asserted.
> +	 */
> +	printf("memcg_async_reclaim_dying: skips on removed cgroup: gone=%llu, dying=%llu\n",
> +	       (unsigned long long)skel->bss->reclaim_target_gone,
> +	       (unsigned long long)skel->bss->reclaim_skipped_dying);
> +
> +	/* Nothing may have been reclaimed from the removed target. */
> +	if (!ASSERT_EQ(skel->bss->reclaim_calls, calls_before, "reclaim_calls"))
> +		goto out;
> +	if (!ASSERT_EQ(skel->bss->reclaimed_bytes, bytes_before,
> +		       "reclaimed_bytes"))
> +		goto out;
> +
> +out:
> +	if (reader_pid > 0) {
> +		kill(reader_pid, SIGKILL);
> +		(void)waitpid(reader_pid, NULL, 0);
> +	}
> +	if (data_file[0])
> +		unlink(data_file);
> +	if (skel)
> +		memcg_async_reclaim__destroy(skel);
> +	cleanup_cgroup_environment();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
> new file mode 100644
> index 000000000000..5033d5ec4c8e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/memcg_async_reclaim.c
> @@ -0,0 +1,259 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +#include "bpf_experimental.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_core_read.h>
> +
> +#define CLOCK_MONOTONIC_ID	1
> +#define PAGE_SIZE		4096UL
> +/*
> + * One reclaim round targets RECLAIM_MAX_ITER batches of RECLAIM_SIZE
> + * each. Each bpf_wq callback reclaims a single batch and requeues the
> + * same work item for the next one, so no callback runs longer than one
> + * bounded reclaim pass.
> + */
> +#define RECLAIM_SIZE		(32 * PAGE_SIZE)
> +#define RECLAIM_MAX_ITER	32
> +
> +struct bpf_args {
> +	u64 high_cgroup_id;
> +	u64 low_cgroup_id;
> +	u64 event_delta_threshold;
> +	u64 check_ns;
> +};
> +
> +struct cgroup_memcg {
> +	struct cgroup *cgrp;
> +	struct mem_cgroup *memcg;
> +};
> +
> +static u64 wq_high_cgroup_id;
> +static u64 wq_low_cgroup_id;
> +
> +/*
> + * Statistics exposed to userspace through .bss, so the test can verify
> + * that reclaim actually happened instead of relying on timing alone.
> + */
> +u64 reclaim_calls;
> +u64 reclaimed_bytes;
> +/*
> + * Reclaim attempts skipped because the target cgroup is dying or has
> + * been removed. reclaim_skipped_dying counts lookups that still found
> + * the cgroup while it is being torn down, reclaim_target_gone counts
> + * lookups that found nothing. The test removes the target cgroup while
> + * reclaim is running and checks that reclaim stops via these counters.
> + */
> +u64 reclaim_skipped_dying;
> +u64 reclaim_target_gone;
> +
> +static int get_cgroup_memcg_from_id(u64 cgroup_id, struct cgroup_memcg *cm)
> +{
> +	cm->cgrp = bpf_cgroup_from_id(cgroup_id);
> +	if (!cm->cgrp)
> +		return -1;
> +
> +	cm->memcg = bpf_get_mem_cgroup(&cm->cgrp->self);
> +	if (!cm->memcg) {
> +		bpf_cgroup_release(cm->cgrp);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void put_cgroup_memcg(struct cgroup_memcg *cm)
> +{
> +	bpf_put_mem_cgroup(cm->memcg);
> +	bpf_cgroup_release(cm->cgrp);
> +}
> +
> +static int get_cgroup_event(u64 cgroup_id, u64 *val)
> +{
> +	struct cgroup_memcg cm;
> +
> +	if (get_cgroup_memcg_from_id(cgroup_id, &cm))
> +		return -1;
> +	bpf_mem_cgroup_flush_stats(cm.memcg);
> +	*val = bpf_mem_cgroup_page_state(cm.memcg,
> +		bpf_core_enum_value(enum node_stat_item,
> +				    WORKINGSET_REFAULT_FILE));
> +	put_cgroup_memcg(&cm);
> +
> +	return 0;
> +}
> +
> +static bool
> +should_reclaim_cgroup(u64 cgroup_id, u64 *prev_event, u64 event_delta_threshold)
> +{
> +	u64 cur, delta;
> +
> +	if (get_cgroup_event(cgroup_id, &cur))
> +		return false;
> +
> +	delta = cur - *prev_event;
> +	*prev_event = cur;
> +
> +	return delta >= event_delta_threshold;
> +}
> +
> +/*
> + * A cgroup is dying once it has been offlined (CSS_ONLINE cleared) or
> + * CSS_DYING has been raised, mirroring cgroup_is_dead()/css_is_dying()
> + * in include/linux/cgroup.h. bpf_cgroup_from_id() can still hand back
> + * such a cgroup, because it only fails once the last reference has been
> + * dropped, so reclaim has to check these flags instead of relying on
> + * the lookup failing.
> + *
> + * CSS_ONLINE and CSS_DYING come from vmlinux.h: the kernel defines them
> + * in an anonymous enum, so bpf_core_enum_value() has no enum type to
> + * bind to, and redeclaring them locally would clash with the vmlinux.h
> + * enumerators. vmlinux.h is generated from the running kernel's BTF, so
> + * the values already match the target kernel.
> + */
> +static bool cgroup_is_dying(struct cgroup *cgrp)
> +{
> +	unsigned int flags = cgrp->self.flags;
> +
> +	return (flags & CSS_DYING) || !(flags & CSS_ONLINE);
> +}
> +
> +/*
> + * Reclaim one batch from the target cgroup. Returns the number of
> + * bytes reclaimed, or 0 if the cgroup is dying or gone or nothing was
> + * reclaimed.
> + */
> +static u64 reclaim_cgroup(u64 cgroup_id, u64 size)
> +{
> +	struct cgroup_memcg cm;
> +	u64 nr = 0;
> +
> +	if (get_cgroup_memcg_from_id(cgroup_id, &cm)) {
> +		reclaim_target_gone++;
> +		return 0;
> +	}
> +
> +	if (cgroup_is_dying(cm.cgrp)) {
> +		reclaim_skipped_dying++;
> +		put_cgroup_memcg(&cm);
> +		return 0;
> +	}
> +
> +	reclaim_calls++;
> +	nr = bpf_proactive_reclaim(cm.memcg, size, -1);
> +	reclaimed_bytes += nr;
> +
> +	put_cgroup_memcg(&cm);
> +
> +	return nr;
> +}
> +
> +struct wq_elem {
> +	struct bpf_timer timer;
> +	struct bpf_wq work;
> +	u64 prev_event;
> +	u64 event_delta_threshold;
> +	u64 check_ns;
> +	/*
> +	 * Bytes still to reclaim in the current round, carried across
> +	 * requeues. 0 means no round is in progress; the timer path
> +	 * starts a new round by resetting it, requeued work only looks
> +	 * at it.
> +	 */
> +	u64 remaining;
> +};
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__uint(max_entries, 1);> +	__type(key, __u32);
> +	__type(value, struct wq_elem);
> +} wq_map SEC(".maps");
> +
> +static int reclaim_work_fn(void *map, int *key, void *value)
> +{
> +	struct wq_elem *elem = value;
> +	u64 nr, size;
> +
> +	if (!elem->remaining) {
> +		/*
> +		 * Timer-triggered entry: start a new round only when the
> +		 * high cgroup refaults enough. Requeued entries skip this
> +		 * check and only look at remaining, so the refault delta
> +		 * is consumed once per round.
> +		 */
> +		if (!should_reclaim_cgroup(wq_high_cgroup_id, &elem->prev_event,
> +			elem->event_delta_threshold))
> +			return 0;
> +		elem->remaining = RECLAIM_MAX_ITER * RECLAIM_SIZE;
> +	}
> +
> +	/* One bounded reclaim pass per callback */
> +	size = elem->remaining < RECLAIM_SIZE ? elem->remaining : RECLAIM_SIZE;
> +	nr = reclaim_cgroup(wq_low_cgroup_id, size);
> +	if (!nr) {
> +		elem->remaining = 0;
> +		return 0;
> +	}
> +
> +	/* try_to_free_mem_cgroup_pages() may reclaim more than requested */
> +	if (nr >= elem->remaining)
> +		elem->remaining = 0;
> +	else
> +		elem->remaining -= nr;
> +
> +	/* Requeue the same work item for the next batch */
> +	if (elem->remaining)
> +		bpf_wq_start(&elem->work, 0);
> +
> +	return 0;
> +}
> +
> +static int wq_timer_cb(void *map, int *key, struct wq_elem *elem)
> +{
> +	bpf_wq_start(&elem->work, 0);
> +	bpf_timer_start(&elem->timer, elem->check_ns, 0);
> +
> +	return 0;
> +}
> +
> +SEC("syscall")
> +int wq_prog_init(struct bpf_args *ctx)
> +{
> +	struct wq_elem *elem;
> +	__u32 key = 0;
> +	int ret;
> +
> +	elem = bpf_map_lookup_elem(&wq_map, &key);
> +	if (!elem)
> +		return -1;
> +
> +	ret = bpf_wq_init(&elem->work, &wq_map, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = bpf_wq_set_callback(&elem->work, reclaim_work_fn, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = bpf_timer_init(&elem->timer, &wq_map, CLOCK_MONOTONIC_ID);
> +	if (ret)
> +		return ret;
> +
> +	ret = bpf_timer_set_callback(&elem->timer, wq_timer_cb);
> +	if (ret)
> +		return ret;
> +
> +	elem->prev_event = 0;
> +	elem->remaining = 0;
> +	elem->event_delta_threshold = ctx->event_delta_threshold;
> +	elem->check_ns = ctx->check_ns;
> +
> +	wq_high_cgroup_id = ctx->high_cgroup_id;
> +	wq_low_cgroup_id = ctx->low_cgroup_id;
> +
> +	return bpf_timer_start(&elem->timer, elem->check_ns, 0);
> +}
> +
> +char _license[] SEC("license") = "GPL";


