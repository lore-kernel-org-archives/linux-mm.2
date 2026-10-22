Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF96606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=DtnTQk/c
Received: by kanga.kvack.org (Postfix)
	id 28D876B09A4; Thu, 22 Oct 2026 13:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EBD6B09A6; Thu, 22 Oct 2026 13:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091DF6B09A7; Thu, 22 Oct 2026 13:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8F8E6B09A4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:38:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5938440216
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:34 +0000 (UTC)
X-FDA: 85350971748.11.B86B15C
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf24.hostedemail.com (Postfix) with ESMTP id 84AB9180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DtnTQk/c";
	spf=pass (imf24.hostedemail.com: domain of 3Fkraag0KCHEPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3Fkraag0KCHEPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792690712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6SRqz0wu3RKsaKxsc5vvLTus3kwMNmtPQXe2gI16No=;
	b=4SPGh+keWyga6QaheH2Jv3UlmiarHdxPLfF+hKB5GKYtkmbcVLikp2EJ0nuziF+0yLyhqj
	yRMZ3Drpdv6YNCHyDo2lk/cyP0xhZ3V4e8E/bSPeh6G5goqpSR0wS6WmASezPDWEVhTF7t
	5o2QEqg3ruu66PNMwzYlTvq31CemFO0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DtnTQk/c";
	spf=pass (imf24.hostedemail.com: domain of 3Fkraag0KCHEPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3Fkraag0KCHEPQWXhWTZQPePiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792690712;
	b=WOUI1cI6UD1HC13pGZ0PhLnTC3ovaPh5eZqh9MNPLTTSoWdt5v39YNLXnFC1zbxpkygd3S
	NezkFR/yKfnJcqrZ0D9JS6NDNnMehX0Tj63++0eiXc+0cV+5EKrnI99tRRbv4zm8Wx7kEB
	jtpYwe5Yi5Agar+UoSA+YB/oaDqeLOQ=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso61806eec.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792690711; x=1793295511; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X6SRqz0wu3RKsaKxsc5vvLTus3kwMNmtPQXe2gI16No=;
        b=DtnTQk/cjzVf211WwwOQi/RWdjuxdpwE5eOxij9TJMwJxk9fQzTOctSOGPwdlRvTy/
         dKstzExqlg+0XPp9QtBGNqrxKDcktAWztztd67Exa351eG8Yt0I3GrsN1djpYMUOUY3e
         d0rZ8yyCjkwhqCNJNLAq16tiMsg+WHsdvreatXfvx60Dr+INdSQnq/yV5RznKUSweXEy
         1KWIMmwqpivC7xjxu/VcJejadkQE4Dd4JnKfmtlp0YwmtEf4LfrQMDmJHqJB6HCenqCg
         jFBoEFNH0zNvMTkoYu3iHf53Rurfnd+wfWNYlIm7Z9+lv32J1zS9tyXM0cDX/ZcBCc3P
         DnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792690711; x=1793295511;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X6SRqz0wu3RKsaKxsc5vvLTus3kwMNmtPQXe2gI16No=;
        b=WG+y1X1AA0Vl1kXJrkfL3JA4uDZpYuGp6fi7m07ohrjEwMnSw9Ix0Tk8WDV2+ob+7H
         /kmrKCtH6R+KxgkrhPbgb+IbqXbfKOVqeshSXzymedv1iZfxIZcjH2kKoch5OLn67gi5
         XRqZtJdmfMZ56OeGHdAy7e2JQmb3n9MTeuDwVvYFUPKt7QmRUgzJZ+H8GYZ7HRS1ZtUk
         baChvVXdZYFCy72iCdmME0Kg74jzBHdfFMFbJrKwS/It5twEaOtDrW1M3AEhwvxZqc0d
         URe9mluCbttwooNuJkW3Tz7Btz3HCAo0CicwK+fYBemKbpKmY23qA74qxpGAWG1TAMQD
         fYdA==
X-Forwarded-Encrypted: i=1; AKwUvBwBEcS9+DG7GMptqAz9s6FK7k8mjAh74f0/EkSYN76S6dXs93WZ0PdWxVocirCsZxG+RRMyqRe1Xg==@kvack.org
X-Gm-Message-State: AFq9FYLIgNO1DP/ts+u+rddl4OiLwORY3M2KbgBeUu2oJmSGhwGH478B
	y+OZ+03k597XmIW9dRyI7wNE9r0cffI8pqjd19IFNp3UynKczEBOzyO6HxWOCLUhGOCWAcSyf35
	mZyT8pg9KDOGUAn7Z1ZpCZQVvh5O1FRolNA==
X-Received: from dybnq2.prod.google.com ([2002:a05:7300:e502:b0:366:233a:49c7])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:6c85:b0:35f:5591:e40c with SMTP id 5a478bee46e88-3674de4ca70mr11857901eec.22.1792690710622;
 Thu, 22 Oct 2026 10:38:30 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:38:23 +0000
In-Reply-To: <cover.1792690544.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1792690544.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <46a82e8f6e901531704ecf14c714e0b83d4e6f36.1792690544.git.abhishekbapat@google.com>
Subject: [PATCH v4 4/4] alloc_tag: Add a test for trace state toggle and filtering
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84AB9180002
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 573phkft7sxtcr6od7nzzfeigpejbdqz
X-HE-Tag: 1792690712-29545
X-HE-Meta: U2FsdGVkX192k4vxLEicM1bBeR9E/tNDN82OJ8aUiqg7Fh2KJwlZoe/k32M4luwdJ4nTrUs8aX6hZ0wFCaxfDzPzUu+AMwr7TXaOUidydICMsWsrQBsdfwMZrtiF8vqPHMVuJk/ZX2DHltv+wbJ4XAxz3rTxVOQKUzA2YoXYedz63ibUzU0BfRKzdxELQx6u89YUhl3jIxC48naXmvl/XdqS7wfcTut8GeqUUpQhMseO0wHg+GxZNw6+bWnAg39R2+HSRHTtg1/jT3XFkQhbA4vWxt+O8WMoNsJFcs8MJGIm24VuDzSGovD6kv157vT67MoVD1W8XHsyr/bJldm4GHy7zxN22YO+weAcp6trEQt1B+ZcHhXuJ5f7vDN+nD9hOWvo1jh6ulZ8xlbDTG9wcvuJcmMB/XnKiiiX7yMIeK+1NbhDd2mttlpEcaMbtm6Mp2IGPwhGUVzhfUQByGuDsjZXURK17Eu2s9/O8h2fxNoxL2/r/+PHlDzjjk4SWEtEwcjkfaGyCRYRtt6lm5MYMKFDJzOqNHMwOmYS02XaqSsW5W6heekpWlgoHJ8icR2MxcrGDdUW+JYb7IHP1tISZ270OKG67dHqnAxP0Od7RH46xmk6d/+IUhEZ19qIF7EPQLBD5ZzMFIz5O9YtbJKIwQe7u38yqsQ1lhR3KZpk4RJgflZt4jhQjVqxMEpLcZTCyWYuUb8AbvA+H++3Tv8oW6kEUgBX9LmPewGs5Jrl74ja12ux1/fG9z7zw2jIwOpIn3NUW5iARsoeXcROWSTcTv8deOct0Lewl5MfN02Axgq1oc0yJVRM+gFTZRDCcF40n40/KlMhMP6jDS/2KEmJYy6LmvKCh1R9Xs1d6j9x/j5D/4pFjci2KF1SovUKd5G/AULNtJWO4fvzmoo/pkra4HSFUF+ZcmSQfC7eTOh2OO1JCkDT+q1vDl2w7ikyeO/+dqDX6EaWyltl74K57c9
 WcRwi0fM
 33EVW6g0I6OltNu/n6AoQaMJPSa8GqmvtFFfx0Vg1ueMvmUfPv0zawDh0FOcL/i/jiurRoWKD0WowPIBhoCIMtVjz6TCNL5HzMUHMp+dnAGlJ4hZUcwizx8WGqC1kw5gLvslWwiw6+Jj0GXev9kLPH86rqZ2dSA9DVWJ52Gr2691reUbLvFkHXzBfUiiMjVv9jTba9etqcKXsJwhiw0QxyDVtwI6DI7ZXA2/Sy8qdfWuzeI7Y3jvW2+rGBHOBGmavR5ZMPL0TeeIOEZCScREqtl/vD8ZxSQ5LMSimJcOMWz1Ypq+GESk2YcxKaKStgZaXhl1ljcBLuzRbZXXOMMUlV6SBfllL3EVtropF1b092CZmg+C/V5f0twvZSUTNK/ivvKTAzi1I8AMd0BBEPV5dWnlrdOzVYEjXU/mp8Hr6duidVZEzEJZaPt+C4utQ9X7P54sAZdmD4Lhi8OgR2tNs66LMQOUjIk5yYByc8SVhpLo2xTsF8PsjPOmrWdWDIBLjK2C9JWBwWpCKjif+6HsTdBwoGtciNaKj0IaOZ0XPXav2i2QeFnmRGM6QemkN48xhuBHKmM1tERWrml4i8XHZ/0Es57wzKD+/PgotNucdtbbSIbTTQEIytonnlLDotcE6m8OIZFfWkE6vcLa+ID21rWNCrdbCrSpFgqvIS8o8EANB8Q4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Following the introduction of the ALLOCINFO_IOC_TOGGLE_TRACE IOCTL and
ALLOCINFO_FILTER_MASK_TRACE_ON filters for selective memory allocation
tracing, update the kselftests to validate this behaviour.

Introduce `test_tracing_toggle_and_filter`, which validates the
architecture by:
1. Dynamically flipping trace execution state for a designated allocation.
2. Query the same tag again, and check that the returned tag reports the
   new state in its `trace_on` field.
3. Restore the tag's original trace state, also on failure, so the test
   does not leave tracing changed on the system.

The test uses `dup_mm()` function name with the function filter in the
IOCTL to run the above steps. If the `dup_mm()` tag is not found, the
test is skipped.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 .../alloc_tag/allocinfo_ioctl_test.c          | 113 +++++++++++++++++-
 1 file changed, 110 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 74fd64b2370c..eb52ca1a1dc4 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -48,6 +48,11 @@ static inline int __allocinfo_get_next(int dev_fd, struct allocinfo_tag_data *pa
 	return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
 }
 
+static inline int __allocinfo_toggle_trace(int dev_fd, struct allocinfo_toggle_traces *params)
+{
+	return ioctl(dev_fd, ALLOCINFO_IOC_TOGGLE_TRACE, params);
+}
+
 static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
 			const struct allocinfo_tag_data *tag_data,
 			bool match_bytes, bool match_calls, bool match_lineno,
@@ -289,6 +294,8 @@ static int run_filter_test(const struct allocinfo_filter *filter)
 	return ret;
 }
 
+static const char *target_test_function = "dup_mm";
+
 static int test_filename_filter(void)
 {
 	struct allocinfo_filter filter;
@@ -304,11 +311,10 @@ static int test_filename_filter(void)
 static int test_function_filter(void)
 {
 	struct allocinfo_filter filter;
-	const char *target_function = "dup_mm";
 
 	memset(&filter, 0, sizeof(filter));
 	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
-	strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
+	strncpy(filter.fields.function, target_test_function, ALLOCINFO_STR_SIZE);
 
 	return run_filter_test(&filter);
 }
@@ -514,11 +520,106 @@ static int test_lineno_filter(void)
 	return ret;
 }
 
+static enum ioctl_ret toggle_trace(struct allocinfo_tag *target_tag,
+				   bool enable)
+{
+	int fd;
+	struct allocinfo_toggle_traces toggle_params;
+
+	fd = open(ALLOCINFO_PROC, O_RDONLY);
+	if (fd < 0) {
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
+		return IOCTL_FAILURE;
+	}
+
+	memset(&toggle_params, 0, sizeof(toggle_params));
+	toggle_params.filter.mask = ALLOCINFO_FILTER_MASK_MODNAME | ALLOCINFO_FILTER_MASK_FUNCTION |
+				    ALLOCINFO_FILTER_MASK_FILENAME | ALLOCINFO_FILTER_MASK_LINENO;
+	toggle_params.filter.fields = *target_tag;
+	toggle_params.enable = enable;
+
+	if (__allocinfo_toggle_trace(fd, &toggle_params)) {
+		close(fd);
+		return IOCTL_FAILURE;
+	}
+
+	close(fd);
+	return IOCTL_SUCCESS;
+}
+
+static int test_tracing_toggle_and_filter(void)
+{
+	struct allocinfo_filter filter = { 0 };
+	enum ioctl_ret ioctl_status;
+	int ret = KSFT_PASS;
+	bool initial_state, target_state;
+	struct allocinfo_tag target_tag;
+	struct allocinfo_tag_data_vec *tags = calloc(1, sizeof(*tags));
+
+	if (!tags) {
+		ksft_print_msg("Memory allocation failed.\n");
+		return KSFT_FAIL;
+	}
+
+	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
+	strncpy(filter.fields.function, target_test_function, ALLOCINFO_STR_SIZE);
+
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
+	if (ioctl_status != IOCTL_SUCCESS || tags->count == 0) {
+		ksft_print_msg("Could not retrieve IOCTL entries for %s\n", target_test_function);
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+
+	target_tag = tags->tag[0].tag;
+	initial_state = tags->tag[0].counter.trace_on;
+	target_state = !initial_state;
+
+	ioctl_status = toggle_trace(&target_tag, target_state);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Failed to toggle tracing\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	filter.mask |= ALLOCINFO_FILTER_MASK_TRACE_ON;
+	filter.tracing = target_state;
+
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Error retrieving IOCTL entries with trace filter.\n");
+		ret = KSFT_FAIL;
+		goto exit_revert;
+	}
+
+	if (tags->count != 1) {
+		ksft_print_msg("Expected exactly 1 entry, but got %llu\n", tags->count);
+		ret = KSFT_FAIL;
+		goto exit_revert;
+	}
+
+	if (tags->tag[0].counter.trace_on != target_state) {
+		ksft_print_msg("Entry returned by trace filter does not match target state\n");
+		ret = KSFT_FAIL;
+	}
+
+exit_revert:
+	ioctl_status = toggle_trace(&target_tag, initial_state);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Failed to revert tracing to initial state\n");
+		ret = KSFT_FAIL;
+	}
+
+exit:
+	free(tags);
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
 
-	ksft_set_plan(4);
+	ksft_set_plan(5);
 
 	ret = test_filename_filter();
 	if (ret == KSFT_SKIP)
@@ -526,6 +627,12 @@ int main(int argc, char *argv[])
 	else
 		ksft_test_result(ret == KSFT_PASS, "test_filename_filter\n");
 
+	ret = test_tracing_toggle_and_filter();
+	if (ret == KSFT_SKIP)
+		ksft_test_result_skip("Skipping test_tracing_toggle_and_filter\n");
+	else
+		ksft_test_result(ret == KSFT_PASS, "test_tracing_toggle_and_filter\n");
+
 	ret = test_function_filter();
 	if (ret == KSFT_SKIP)
 		ksft_test_result_skip("Skipping test_function_filter\n");
-- 
2.56.0.257.gf7497c7d27-goog


