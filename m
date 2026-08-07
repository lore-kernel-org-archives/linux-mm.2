Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D23C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A896B00A4; Fri,  7 Aug 2026 07:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F52C6B00A5; Fri,  7 Aug 2026 07:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4406B00A6; Fri,  7 Aug 2026 07:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1222B6B00A4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9869E160343
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:24 +0000 (UTC)
X-FDA: 85074272808.23.14670EE
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf06.hostedemail.com (Postfix) with ESMTP id 980F7180003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u xQ/dJq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=lDWQSBXl;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tAM9g0684oRzmvSRuRjYFDutiQh5p3+9TYSRlUK8Mw=;
	b=xnLZjvI16QrbbbIq7Bt7uiWPjbN36jbZo3whTK53BKC5XWnGQjvP5lcwFkvoJveEdRTbPO
	/1uX3XvevSawLFoZ2rNfvBA8WFco0YhimCUE+n+/8274Fj7ZCyqHX8/iun4cNdZF/GHUh4
	CraUve2EGRdE/LzxN5V4A2fJRmoCBHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102642;
	b=FhIXpgi48DrUKc9xA95Fnqgd8je7iBKXEtOhHeZct+d//XVoqZxxWEqUrHuN9dVah7lNsX
	TbgyCoFbs0UL0jL+hBfNR/ek0+g7qz4AtzzHweU+bVgOzO3K3haKOs51HfrrKwmMRbSOVS
	yILcr5P9m9rM57mwPQo1jnO0JdeFSKQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u xQ/dJq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=lDWQSBXl;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 617787A00AC;
	Fri,  7 Aug 2026 07:37:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 07 Aug 2026 07:37:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102641; x=
	1786189041; bh=8tAM9g0684oRzmvSRuRjYFDutiQh5p3+9TYSRlUK8Mw=; b=u
	xQ/dJq3m96Z/ZX7AptbBwSbJbBFxJ609byOlEM2pwXJd1CxA+YRqkzFU+5NMyjpf
	gyRQItI7A2JW9deYSn8Ij3P+7FqFQBeBR4j9D1IfnE/Etv4tvqOmMhBWo7NBivJB
	BKVnzMyy/Euv2UHcqssGhRXX8y05vqyO01VVXl3lOTw1WtptB7dyIXdabtWTLqbj
	33YWyYUlmTxL8uSHLNPqhoZxPr+EDUmabcLDwR4HxR0JwSWzaDazCp4b1F9or2ub
	e2+2tsChoQUvEOiETCbW7LYDZGcJjGVWSWTXcwIiapQu5IxqzdWbjMnHQfRA/fAg
	RXroHxsm6YKiUuj5dvq6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102641; x=1786189041; bh=8
	tAM9g0684oRzmvSRuRjYFDutiQh5p3+9TYSRlUK8Mw=; b=lDWQSBXldyOvTowSo
	o6jgucV1dVhi0gMv74hLWH5exR77eRY65K9uwEA78XGs1C0YTXWpPjJsVJDKIK0d
	A+VyamLVS/IrMVfAjVb7nGiEggCrX/7TRZCWDfqsHEDqndr7/88KwmDp+ijsWRp1
	JC7ijWRQgR56yrmbnXCuFF0mYW2A2KqLrrkFzhByoWx2qUaAmKPty8bbNKvTKlX0
	P9OAPuBZH3Jrg/8TFOkJ3toquxM/8+OEy/CUm57w6S/UiH707xctWKX68rDjA1pq
	lZqepM420O39dDyKrdbA3Ius3U9LnJRWS3rXjyUXihv36zznVYYMCSRu7mxmT/5E
	xbYAA==
X-ME-Sender: <xms:ccN1alpZ-htQ22EjGYoxHQBK83qOWvDMI0XsRL_3J9BoCxBwQas_tg>
    <xme:ccN1ajgnlInnW3O97FOx_smDlIGsXqD_IayBbDEthjI5s8UqwYv34mPPFJ2v5AzUN
    ZN9b1c3uaL--noDbkfyEU0p7RjPlOfBhhruweDz5My04J0PLvfvI2-T>
X-ME-Received: <xmr:ccN1arATzdjV6UJt2gxFutlKlPH_P4vLzKd1Ky5qVQxxQXTU-2kD2OfKr4c>
X-ME-Proxy-Cause: dmFkZTFHgVqOo5hmjJljb3IAZGkXyyxzQaD6i5RNmNk424gVmZkPzr1NfNWN42YMHBLBJ7
    ouwgSkV7uP+O116AnyQ77X3VN5vAdqq1zvzV33EYJRHUa/cQ0OT9UF9tJbf4RJE1rh86et
    dgK/XsSmEjRvIZ4/DwnHkulf5IWkeizHGDAErUJF9mnMadsJqDG0SAHuOjgfipI02yAqvF
    a9Gp7D1P4aM7ojieUjy73reTq6pHjAlslJzhWF2Bayc7rzuN1loFnb3tH1A/9l8/u/BKz2
    kEn4hJCLyjrltgNf/ADveISAZdc/G8K4aY+0IiJqAeENTN6qSce54NhN3knOmRl67eS+iD
    DB/QX6xfKcr5RTHe3Fwx41XsDl2llue/0k0iHG3Lz7tcse7fjrM4kmFD8x/ltDWFR0S/6j
    g3jExQ3/y710ZEVdf1dY9K2eOWeoheh/bH9sPncAG9GLM5pJu54o3R4VujgiqolMtPX0X6
    VAUv9x8ygaHlyqBsODovA5QpLCdyzh6DJdbfrASOOyXwujHMs54A+S+kcowCkvEM/m8zUb
    XrRjdcnMoWOMC6MRih1xZPflaVhp0PV4JZIZSU3B0R9lN6jFv0whY8PKf9CAAP5ZtbaCtC
    3nzgoZtL52vh1X/MauVErS5FJMqE0ozjCuUuESABlSc0ZsELK58+Z1nmeGPg
X-ME-Proxy: <xmx:ccN1apvUCSTo-uJ-CZpG7lwooS66gGcobpDVDrPk39F1N5ZYrKjR1Q>
    <xmx:ccN1at7ZX5VIwcROk2twQPER_rN3_vJVx92NszRJoi5G0nD6qDQSNA>
    <xmx:ccN1arddJmRYdlyvfSxu3ul73nNdXbcWEq9hV05oCsCN1YdKHRKaEQ>
    <xmx:ccN1atV_3ovA28iNUk4qUHGbu84Wttw_g3T0N0dIc2aVP7JmMkB-dA>
    <xmx:ccN1ajyEFeRlmXYwLC4lE5ljDNMSB_ub388NQ6FgKu9jhgXEeN43UEWw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:20 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v2 12/17] selftests/mm: run every supported collapse order by default
Date: Fri,  7 Aug 2026 12:36:42 +0100
Message-ID: <20260807113647.3744609-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 980F7180003
X-Rspam-User: 
X-Stat-Signature: 4n8jsgitsmym3745bmfx91prm3kkk4qu
X-HE-Tag: 1786102642-777038
X-HE-Meta: U2FsdGVkX1+zoEuUztOtx9OkNkbf3Dkh/C4FaCTX8x5uDVw+9vwEdqFtXKsw9hQ379+M4Kv85Wc/Gy3pDHHa7/n+CNpLtCQSqiwZLOcLF1EYzdSUWVysJ4qnDHk0EJ9hR/wtwYJJQdQjvdvS3/SM8tHYBQPVJ4FcFM4agsbH6F+HnVF1vQXS1o9k+UquTYIjst++j775D152uuE2EA2eHrq+mJxWs0ajA6ZBA3+z9zP7Sojx7ow9q0pnWW2OsVxK/lhSrwEat9No4iRqaBxcJju7cLwqKSFyXmoLUcEZCfkgcn1XPnNCw61IduAmA6qvpTY4Z346IG6RuBceKOR/q8DhKbTSDxN6l51RAea0It0h5iQ4ZEXjaj7WDkUIGaE2PYy42BKyZT251d3PUP+JTdQzpecw93MAmDu4hv0nNO+BPqTyI79Uvqgs6kUHbKVPPPcVgmZ8I7w+DNlRbmiQeN0ikI9LN5BCxiJuDZOev3T//SfaNO1z1X/oKralFuWiGRiFVcEprL/FZMbKSx/e+085DI9JeFi99ANw7i+K7TuTg/4EvHJiD/8dE29kDF3M55CiVkpcmTPvcyraWn39TH+6xBeOe7rzvbuuk9DCaNWW4oo7JAUU8QAbQxqsO17o9FYCODTeRSHbxW4npj/239hWCkH0wm5Xr0iXtOmSkT2mo/kgiJaifsD9YikAaP9O773V0ASmOhLALz2ltojz9dIewjYQuMeHEWagZYtLWx5e0fNJJtYYJ1nFUGUdVunl0JyuWeqS4L1vpOMWr5EB63qHXnW+YJ5eh2Z2udEzpu5NktfTvwE4w2FVft8mpNRpydF998kETvKNyTYZuJ5NvfhpU1id4+yX8LDUU0tQmtzH6nAetx14O+zUAaiNp1bFM8pnwZtsECtsG3uc7PFT1imB56x3SN5eelBYAPoDEG3z57MZ9A6IXcnyVTWGmKrhI/bWWIypvo21lK+wb0H
 ApElASiW
 eDX9dy0naugExyUWtdXk+tyVBrpVb/kCulH3Ox9Eqdk9NKNMDzqmvSD4Q31+wNnTuHbVJVcF4RoWEHHm3xd6l1UwZ4JxdDocmM+0MD5d2oz0WW5lHBNhXAscZLU/Z3BTBX02ToNvpeDuyyQ9Hh1f28AZ5itjRKE5eVNE0DK/PgiSuT7OIL8Zf+neSbv6EyUQzErpbWBb49OriVLIqPsy6QKY2i+JYCufzP6Qsyy/5fIOWtfoNz/XuT+PgB1kmollyHqhTi9cX6Q8jIMwccMwJJfo0/J5o85GWRHl07rH1O4Gld5i3t69YOK4b5p8KyNrgVuAUTEGK1BBDyG2QlV1TzoitaDmvwIe5jj6U+ADv03oPO/ml7bDrXtYNPrOFUExdXqQ8EgvlndwyoYtqRf4MF6PgGvH49YdwcGGgRfcu6eprOv8XUP5Thhjw+ljmAY+8mmfK9+y9kEJJ5PA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The mTHP collapse cases only run when the caller names both the context
and an order, so a plain ./khugepaged covers the PMD contexts on anon and
nothing else.  run_vmtests.sh pinned order 4 and covered no other.

Without -c, run the mTHP cases once per supported anon THP order below the
PMD, and include that context in both the no-argument invocation and
"all".  -c still pins one order, and now says what is wrong when the order
is above the PMD or unsupported instead of printing the usage text.  An
order at or below the -s source order is skipped: the sources would
already be the size being asked for.

Both orders end up as array indices and shift counts, so -s rejects a
negative order and -c anything at or below 0, rather than letting either
reach them.

The mTHP context has only anon cases, so a run that names a different
mem_type -- "all:shmem", say -- drops it again rather than refusing to
start.  Naming both explicitly still does.

A case carries the order it was registered at, so a result names it:

  # Run test: collapse_order_max_ptes_none (mthp_khugepaged:anon, order 6)

On x86-64 with 4K pages that is orders 2 through 8, and ./khugepaged goes
from 28 results to 77 in 21 seconds, so run_vmtests.sh can drop its pinned
order-4 line.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   | 111 ++++++++++++++++++----
 tools/testing/selftests/mm/run_vmtests.sh |   2 -
 2 files changed, 91 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index a5683f08694f..a202fe359cf6 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -31,6 +31,9 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
 static int collapse_order;
+static bool collapse_order_given;
+static int collapse_orders[NR_ORDERS];
+static int nr_collapse_orders;
 static int pagemap_fd = -1;
 static int kpageflags_fd = -1;
 
@@ -1556,6 +1559,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    Defaults to every supported order below the PMD.\n");
 	fprintf(stderr,	"\t\t    With -s, -s names the mTHP source order for the\n");
 	fprintf(stderr,	"\t\t    mixed-source case (source order below the target).\n");
 	exit(1);
@@ -1563,6 +1567,7 @@ static void usage(void)
 
 static void parse_test_type(int argc, char **argv)
 {
+	bool mthp_context_implied = false;
 	int opt;
 	char *buf;
 	const char *token;
@@ -1574,6 +1579,7 @@ static void parse_test_type(int argc, char **argv)
 			break;
 		case 'c':
 			collapse_order = atoi(optarg);
+			collapse_order_given = true;
 			break;
 		case 'h':
 		default:
@@ -1581,12 +1587,23 @@ static void parse_test_type(int argc, char **argv)
 		}
 	}
 
+	/*
+	 * Both orders end up as array indices and shift counts, so neither
+	 * can be negative, and a zero collapse order asks for base pages.
+	 */
+	if (anon_order < 0)
+		ksft_exit_fail_msg("-s takes an order, which cannot be negative\n");
+	if (collapse_order_given && collapse_order <= 0)
+		ksft_exit_fail_msg("-c takes an order above 0, not %d\n",
+				   collapse_order);
+
 	argv += optind;
 	argc -= optind;
 
 	if (argc == 0) {
-		/* Backwards compatibility */
+		/* Everything that needs no argument of its own: anon, every context */
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
 		anon_ops = &__anon_ops;
 		return;
@@ -1597,13 +1614,19 @@ static void parse_test_type(int argc, char **argv)
 
 	if (!strcmp(token, "all")) {
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
+
+		/*
+		 * "all" sweeps the mTHP context in, but it only has anon
+		 * cases: step it aside for the other mem_types rather than
+		 * refusing the whole run.
+		 */
+		mthp_context_implied = true;
 	} else if (!strcmp(token, "khugepaged")) {
 		khugepaged_context =  &__khugepaged_context;
 	} else if (!strcmp(token, "mthp_khugepaged")) {
 		mthp_khugepaged_context =  &__mthp_khugepaged_context;
-		if (collapse_order <= 0 || collapse_order >= hpage_pmd_order)
-			usage();
 	} else if (!strcmp(token, "madvise")) {
 		madvise_context =  &__madvise_context;
 	} else {
@@ -1619,20 +1642,20 @@ static void parse_test_type(int argc, char **argv)
 		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
-		if (mthp_khugepaged_context)
-			usage();
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
 		read_write_file_read_ops =  &__read_write_file_read_ops;
 		read_write_file_write_ops =  &__read_write_file_write_ops;
-		if (mthp_khugepaged_context)
+		if (mthp_khugepaged_context && !mthp_context_implied)
 			usage();
+		mthp_khugepaged_context = NULL;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
-		if (mthp_khugepaged_context)
+		if (mthp_khugepaged_context && !mthp_context_implied)
 			usage();
+		mthp_khugepaged_context = NULL;
 	} else {
 		usage();
 	}
@@ -1654,9 +1677,14 @@ struct test_case {
 	struct mem_ops *ops;
 	const char *desc;
 	test_fn fn;
+	int order;		/* mTHP contexts: the collapse order */
 };
 
-#define MAX_TEST_CASES 64
+/*
+ * Enough for every case at every order the kernel offers: the mTHP context
+ * runs its cases once per supported order below the PMD.
+ */
+#define MAX_TEST_CASES 256
 static struct test_case test_cases[MAX_TEST_CASES];
 static int nr_test_cases;
 
@@ -1669,6 +1697,7 @@ static int nr_test_cases;
 			.ops	= o,					\
 			.desc	= #t,					\
 			.fn	= t,					\
+			.order	= collapse_order,			\
 		};							\
 	}								\
 	} while (0)
@@ -1709,10 +1738,40 @@ int main(int argc, char **argv)
 
 	parse_test_type(argc, argv);
 
-	if (mthp_khugepaged_context &&
-	    !(thp_supported_orders() & (1UL << collapse_order)))
-		ksft_exit_skip("Order %d is not a supported anon THP order\n",
-			       collapse_order);
+	if (mthp_khugepaged_context) {
+		unsigned long orders = thp_supported_orders();
+
+		if (collapse_order_given) {
+			/* -c pins one order; it has to be one we can build */
+			if (collapse_order >= hpage_pmd_order)
+				ksft_exit_fail_msg("-c takes an order below the PMD order (%d)\n",
+						   hpage_pmd_order);
+			if (!(orders & (1UL << collapse_order)))
+				ksft_exit_skip("Order %d is not a supported anon THP order\n",
+					       collapse_order);
+			if (collapse_order <= anon_order)
+				ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
+					       collapse_order, anon_order);
+			collapse_orders[nr_collapse_orders++] = collapse_order;
+		} else {
+			/*
+			 * Otherwise every order a collapse could produce.  -s
+			 * makes the fault path hand out folios of that order,
+			 * so a target at or below it has nothing to collapse:
+			 * the sources are already the size being asked for.
+			 */
+			int first = anon_order ? anon_order + 1 : MIN_MTHP_ORDER;
+
+			if (first < MIN_MTHP_ORDER)
+				first = MIN_MTHP_ORDER;
+			for (int i = first; i < hpage_pmd_order; i++) {
+				if (orders & (1UL << i))
+					collapse_orders[nr_collapse_orders++] = i;
+			}
+			if (!nr_collapse_orders)
+				ksft_print_msg("mTHP cases skipped: no order above the source\n");
+		}
+	}
 
 	if (mthp_khugepaged_context) {
 		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
@@ -1773,7 +1832,17 @@ int main(int argc, char **argv)
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
-	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+	for (int i = 0; i < nr_collapse_orders; i++) {
+		collapse_order = collapse_orders[i];
+		TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
+	}
+
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
 	TEST(collapse_full, madvise_context, read_write_file_read_ops);
@@ -1781,14 +1850,8 @@ int main(int argc, char **argv)
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
-	TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
-	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
@@ -1862,7 +1925,15 @@ int main(int argc, char **argv)
 	for (int i = 0; i < nr_test_cases; i++) {
 		struct test_case *t = &test_cases[i];
 
-		ksft_print_msg("\n# Run test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		if (t->ctx == &__mthp_khugepaged_context) {
+			collapse_order = t->order;
+			ksft_print_msg("\n# Run test: %s (%s:%s, order %d)\n",
+				       t->desc, t->ctx->name, t->ops->name,
+				       t->order);
+		} else {
+			ksft_print_msg("\n# Run test: %s (%s:%s)\n", t->desc,
+				       t->ctx->name, t->ops->name);
+		}
 		t->fn(t->ctx, t->ops);
 	}
 
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 2652a7920b80..8bf898b71350 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,8 +412,6 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
-CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
-
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-- 
2.54.0


