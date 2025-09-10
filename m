Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62428CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 17:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25B48E0005; Wed, 10 Sep 2025 13:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6E08E0002; Wed, 10 Sep 2025 13:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E7C8E0005; Wed, 10 Sep 2025 13:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9010E8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:00:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40D021DA82A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:00:29 +0000 (UTC)
X-FDA: 83873954178.06.09D2C56
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44F1F100021
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:00:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YfuUjH38;
	spf=pass (imf14.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757523627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ii1zp41sejenDdX+Fc0ZqaS5dEwSpPRBnvyGP/EInUw=;
	b=EqmhxNvXi5MdUtmTZoCUPr5P0kcxv4StGRwr8Rd3K8Ko1cJCJ6odHZ4veqRK4BZqLsVG4k
	EOzxN/cIBpKulRPe9hD7k7CxEqjwKeFjlCjAqSfCsqkhijELxJguZxbJHJWkXjXXXQrzdS
	WUZqfMWpt65A/mclXKlYjZhUPfTA48o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757523627; a=rsa-sha256;
	cv=none;
	b=kugyaKgY9lzQ1WDycqU6WQ++dxpYYRJrNVRGPjHX67UZFn+0cCcOxD0Blcns0H8/B9flPj
	kwU3qZjEjTy3ruojkMaEkq6LCkpZSwqND4iv57kyS+qzP19IU0M6LX15ZIK8y+NAXzOICa
	WzcOljgzMElpWS/PPGeMCj9c9JdSBpo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YfuUjH38;
	spf=pass (imf14.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757523626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ii1zp41sejenDdX+Fc0ZqaS5dEwSpPRBnvyGP/EInUw=;
	b=YfuUjH38dnXdrgN/NVwZcNLzR2E3GYnxZG1QQEVxFEqs+waZM+khiCtJldak0cN7JPwzK+
	V55XvqxF2tygFm19FGqHn2fTZQSEAf9gEOiiFbt/a1snt71qmSHGoO443u8jBvU78S3irB
	nPyNqzRfUuounMRTPpXGNQv7V7pBvAI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-38-CvBpK9KkO1SOHH-ct7Qx8w-1; Wed,
 10 Sep 2025 13:00:23 -0400
X-MC-Unique: CvBpK9KkO1SOHH-ct7Qx8w-1
X-Mimecast-MFC-AGG-ID: CvBpK9KkO1SOHH-ct7Qx8w_1757523621
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3DF9195419F;
	Wed, 10 Sep 2025 17:00:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.22.10])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBB781956095;
	Wed, 10 Sep 2025 17:00:14 +0000 (UTC)
From: Gabriele Paoloni <gpaoloni@redhat.com>
To: shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech,
	acarmina@redhat.com,
	kstewart@linuxfoundation.org,
	chuckwolber@gmail.com,
	Gabriele Paoloni <gpaoloni@redhat.com>
Subject: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing testable code specifications
Date: Wed, 10 Sep 2025 18:59:58 +0200
Message-ID: <20250910170000.6475-2-gpaoloni@redhat.com>
In-Reply-To: <20250910170000.6475-1-gpaoloni@redhat.com>
References: <20250910170000.6475-1-gpaoloni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 44F1F100021
X-Stat-Signature: mcfytwc4kzij89cep9ghpthkup31jgt1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757523627-91801
X-HE-Meta: U2FsdGVkX1/iVyOzV0q32UYLlzIl5MOqwcq1hXKn7JX0GZzysL1OVVqQpjnOGInPbojHO1w/kWABujfp90ghOZEQQoC0bYJ+qFavSrc6Lgt5Z5kP5hd1Oo06UyqvdiBaaWe6qAz7iGzA7po97/qkpMCsepKK5JSXu5J70XJIuGLNX+1Ueb5CF0u/RR6QLtZJQOpEvmrVVCBPAS+brZEyZtXyZooYeb8wmJjnFpNVhBikN6nkvxprzIMK+iP1ZthrXqIyQmat9pJ2W7d2aWglWdIJ0Dg/ZTuf1x13h5ubn9u3B5cR5aBwGMwz7Xo4/f35XYXAt6d/9hBwcli8zHDkj7mfu+HvGuBo5/vlZ8d+m7z7+Sol5UwCuf5LXVgVYvgFIz0DDGwRqAAdVUMZHMAPZTFBonr65UV7rJqDXaDX95R30TfllC8TyBRt6orbzC9IVOgj0yQ7PexAF1qpmHmLSI1UnLyjBDRAZziYk58FxEw9JljG1XmEXWiiNbLb92zIsPSG20qEXrDApCJXwO3lkHXFiPuCldq4tlnawHBbWt7k3r6gkZUaHJygFNp+NVwhk82yOhAmOuvg2kGVdzK5QCI07rLLHr9Z1KxR3za6NgcRg3gbkuyBOn5v15Av/BUTFroukm5itXsZVrq8H5l1LHGmQY5Y9jUaxdKhE27xSz4EUDcMm+Nq9EPY3QE0Ftr5FvHuTWTVdmdX9fGipNbgix8zZOxrx/lh323zxy7nwHc7SIUj+QJvWjZ1hazNsbfvBrik/h92cv5tErgLMb9DROnOwPhkV17Wn7uq+Rlr9DbB3hW8Zebl8U9QxufewhJpj2kLesdgQ//Qkxr6uHhyrzaDsh7ObAvCC1/2RkpxruryHjv/4bkh/kHIf/gTPScTdLJNXv6jElrq2jYftTBVJqGoP+0JXTPpvpK8D56iWiB4zrLSGJrKTMrRYmL/0xxrn8yCS9I8Z5qyfmzCVw7
 lyfG+LqJ
 DUZ2z1ag50FK+wm6kU+dZUHno2f68T30PPQElX02QM0/+EBpGxjVSxYp9uuY1JwmZWaXGRtDrV4J6WL+NNENVzbC2im64D5AXVpzsd5VUAuFUkGgCdzqesACxYF4mWiqspFJLyLMaaWBoaFOkWN9Xm3mz5dQg11cEqkhf0bABK7YMIYsalTCuyOKydZbl3sJBn4RkzrSazbuPTgqa8OL3dRTO1Os3nab6aIZ333I9guSM9WVyO5Q6F+2arIuQnEudgG2rUWcr65o1pKLxHG0LpOpntdEIcXoUNnoLx+480vo5suvJ6NxppohvgVrygCMt70T4Z+rrS7ZA2gadnX0dBCkhIYXHKM89MXUTYLMhuWu17u3qT2R+cXJTiixcWZTdKYMdYZI4nkBiEs5KwTnGV0go7j4FS3/077tfp5l5ZjMPa4M0wED5BOhNqozTOjExNub2vv3XeZmkPFpNpVc2bDiFBnS3iNz8G9eMrW0SHKtB/Ck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Documentation/doc-guide/kernel-doc.rst chapter describes
how to document the code using the kernel-doc format, however
it does not specify the criteria to be followed for writing
testable specifications; i.e. specifications that can be used
to for the semantic description of low level requirements.

This patch adds a guideline that defines criteria to formally
describe developers’ intent at the function and subfunction
level in the form of testable expectations.

Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
Signed-off-by: Chuck Wolber <chuckwolber@gmail.com>
Signed-off-by: Kate Stewart <kstewart@linuxfoundation.org>
---
 .../doc-guide/code-specifications.rst         | 208 ++++++++++++++++++
 Documentation/doc-guide/index.rst             |   1 +
 2 files changed, 209 insertions(+)
 create mode 100644 Documentation/doc-guide/code-specifications.rst

diff --git a/Documentation/doc-guide/code-specifications.rst b/Documentation/doc-guide/code-specifications.rst
new file mode 100644
index 000000000000..dee1b4f089e1
--- /dev/null
+++ b/Documentation/doc-guide/code-specifications.rst
@@ -0,0 +1,208 @@
+.. title:: How-to write testable code specifications
+
+=========================================
+How-to write testable code specifications
+=========================================
+
+Introduction
+------------
+The Documentation/doc-guide/kernel-doc.rst chapter describes how to document the code using the kernel-doc format, however it does not specify the criteria to be followed for writing testable specifications; i.e. specifications that can be used to for the semantic description of low level requirements.
+
+This chapter defines criteria to formally describe developers’ intent at the function and subfunction level in the form of testable expectations.
+
+A Virtuous Cycle
+----------------
+By adding testable specifications at the function or (where relevant) subfunction level, one enables the creation of a virtuous cycle when testing is supplemented with open source code coverage tools like llvm-cov or Gcov.
+
+As a true reflection of developer intent, code specifications inform the creation of a pass/fail tests which can then be assessed in conjunction with code coverage tools. A failing test may indicate broken code or specifications that fail to capture developer intent. A gap in code coverage may indicate missing specifications, unintended functionalities, or insufficient test procedure.
+
+High level goals
+----------------
+The code specifications:
+
+1. Should be maintainable together with the code.
+2. Should support hierarchical traceability to allow refinement of SW dependencies (i.e. cross reference critical APIs or data structures).
+3. Should describe error conditions and success behaviors.
+4. Should describe conditions to be met by the user to avoid unspecified or unwanted behaviours.
+5. Should allow covering both static and dynamic aspects of the code.
+6. Should be compatible with Documentation/doc-guide/kernel-doc.rst.
+7. Should support the definition of a test plan (i.e. syntax should enforce testability as well as the avoidance of untestable specifications, e.g “function_xyz() shall not do something”).
+
+Format and Syntax
+-----------------
+Testable code specifications must be written according to the syntax already defined in Documentation/doc-guide/kernel-doc.rst with additional rules that are described below.
+
+Function name
+~~~~~~~~~~~~~
+``* function_name() - Brief description of function.``
+
+This field is to be considered informative and is not part of the testable specifications.
+
+Input Arguments
+~~~~~~~~~~~~~~~
+Input arguments should be specified in a way that better supports the function’s expectations and Assumptions of Use described below.
+They must not contradict the function's expectations and the function’s prototype. For example::
+
+ * trace_set_clr_event - enable or disable an event
+ * @system: system name to match (NULL for any system)
+ * @event: event name to match (NULL for all events, within system)
+ * @set: 1 to enable, 0 to disable
+ *
+ [...]
+ *
+ */
+ int trace_set_clr_event(const char *system, const char *event, int set)
+
+Above all the parameters clearly introduce the impact that they have on the code specifications.
+
+However if below we had::
+
+ * trace_set_clr_event - enable or disable an event
+ * @system: system name to match (NULL for any system)
+ * @event: event name to match (NULL for all events, within system)
+ * @set: true to enable, false to disable \
+ [...]
+ */
+ int trace_set_clr_event(const char *system, const char *event, int set)
+
+In this case @set would be a bad definition since it is defined as an integer and not as a boolean.
+
+Longer Description
+~~~~~~~~~~~~~~~~~~
+The `Longer Description` section is where the large part of testable code specifications are defined. The section must be organised as follows::
+
+ * (Summary Description) provides an introduction of the functionalities
+ * provided by the function and any informal note. This text does not
+ * represent any testable code specification.
+ *
+ *
+ * Function's expectations:
+ * [ID1] - [code expectation]
+ *
+ * [ID2] - [code expectation]
+ *
+ * [...]
+ *
+ * [IDn] - [code expectation]
+ *
+ * Assumptions of Use:
+ * [ID1] - [constraint to be met by the caller]
+ *
+ * [ID2] - [constraint to be met by the caller]
+ *
+ * [IDn] - [constraint to be met by the caller]
+ *
+
+When writing the above section the following rules must be followed:
+
+* No rules apply to the text above ``Function’s expectations``; such a text does not constitute testable specifications and it is just informative;
+* Both ``Function’s expectations`` and ``Assumptions of Use`` must be listed prefixing each of them with an ID that is unique within this kernel-doc header. The reason for this is to facilitate cross-referencing and traceability between tests and code specifications.
+* A Function’s expectation is a testable behavior that the function is expected to comply with (i.e. the function is expected to behave as defined in the function’s expectation).
+* An Assumption of Use is  a pre-condition to be met when invoking the function being documented.
+* Testable functional expectations and Assumptions of Use must be constructed according the same rules that apply when writing software requirements:
+    * Statements should include a subject and a verb, together with other elements necessary to adequately express the information content of the specifications.
+    * The verbs are required to use the following keywords:
+        * For mandatory expectations the verb ‘shall’ is to be used;
+        * For descriptive text that do not constitute a testable expectation verbs such as ‘are’, ‘is’, ‘was’ are to be used;
+        * Negative expectations must be avoided (e.g. ‘shall not’ must be avoided).
+* Statements must be constructed according to the following scheme:
+
+    [**Condition**] [**Subject**] [**Verb/Action**] [**Object**] [**Constraint of Action**].
+
+    In this regard [**Condition**] and [**Constraint of Action**] could be omitted respectively if the [**Action**] being specified must always happen or if there are no constraints associated with it.
+
+Function Context
+~~~~~~~~~~~~~~~~
+The function’s context represents an integral part of Function’s expectations and Assumptions of Use, where these can further specify the information contained in this section.
+
+Without further specifications this section is to be interpreted as per example below:
+
+``* Context: Any context.``
+
+The function shall execute in any possible context.
+
+``* Context: Any context. Takes and releases the RCU lock.``
+
+The function shall execute in any possible context.
+The function shall take and release the RCU lock.
+
+``* Context: Any context. Expects <lock> to be held by caller.``
+
+The function shall execute in any possible context.
+<lock> is assumed to be held before this function is called.
+
+``* Context: Process context. May sleep if @gfp flags permit.``
+
+The function shall execute in process context.
+The function shall sleep according to @gfp flags definitions
+
+``* Context: Process context. Takes and releases <mutex>.``
+
+The function shall execute in process context.
+The function shall take and release <mutex>.
+
+``* Context: Softirq or process context. Takes and releases <lock>, BH-safe.``
+
+The function shall execute in process or Softirq context.
+The function shall take and release <lock>.
+The function shall safely execute in bottom half contexts.
+
+``* Context: Interrupt context.``
+
+The function shall execute in interrupt context only.
+
+It is a good practice to further specify the context specifications as part of the Function’s expectation (e.g. at which stage a lock is held and released)
+
+Return values
+~~~~~~~~~~~~~
+Return values must be written as a multiple line list in the following format::
+
+* Return:
+* * [value-1] - [condition-1]
+* * [value-2] - [condition-2]
+* * [...]
+* * [value-n] - [condition-n]
+* * Any value returned by func-1(), func-2(),...,func-n()
+
+In such a format ``[value-i]`` must be a clearly identified value or range of values that is compatible with the function prototype (e.g. for a read() file operation, it is ok to define [value-i] as ``the number of bytes successfully copied to the user space buffer``).
+
+``[condition-i]`` must be a condition that can be unambiguously traced back to the ``Function’s expectations`` or ``Context`` defined above; as part of [condition-i] it is possible to refer to dependencies of invoked functions or of internal SW or HW states.
+
+``Any value returned by func-1(), func-2(),...,func-n()`` defines a scenario where the current function is directly returning the value of an invoked function dependency.
+
+Semantic aspects of testable specifications
+-------------------------------------------
+From a semantic point of view it is important to document the intended or expected behavior (from a developer or integrator point of view respectively) in consideration of the different design aspects impacting it.
+
+Such behavior shall be described in a way that makes it possible to define test cases unambiguously. \
+To this extent it is important to document design elements impacting the expected behavior and the design elements characterizing the expected behavior (and sometimes these can physically overlap); such design elements shall be limited to the scope of the code being documented, that can range from a single function to multiple ones depending on the complexity of the overall code.
+
+**Possible elements impacting the expected behavior** of the code being documented are:
+
+* Input parameters: parameters passed to the API being documented;
+* state variables: global and static data (variables or pointers);
+* software dependencies: external SW APIs invoked by the code under analysis;
+* Hardware dependencies: HW design elements directly impacting the behavior of the code in scope;
+* Firmware dependencies: FW design elements that have an impact on the behavior of the API being documented (e.g. DTB or ACPI tables, or runtime services like SCMI and ACPI AML);
+* Compile time configuration parameters: configuration parameters parsed when compiling the Kernel Image;
+* Runtime configuration parameters (AKA calibration parameters): parameters that can be modified at runtime.
+
+**Design elements characterizing the expected behavior** of the API being documented that are in scope according to the above mentioned granularity:
+
+* API return values, including pointer addresses;
+* Input pointers: pointers passed as input parameter to the API being documented;
+* state variables: global and static data (variable or pointers);
+* Hardware design elements (e.g. HW registers).
+
+**Testability considerations**: the impact of each of the documented “design elements impacting the expected behavior” must be described in terms of effect on the “design element characterizing the expected behavior” and, in doing so, it is important to document allowed or not allowed ranges of values, corner cases and error conditions;  so that it is possible to define a meaningful test plan according to different equivalence classes.
+
+**Scalability and maintainability considerations**: the described expected behavior must be limited to the scope of the code under analysis so for example the Software, Firmware and Hardware dependencies shall be described in terms of possible impact on the invoking code deferring further details to the respective documentation of these.
+
+When deciding the scope of the code being documented, the scalability and maintainability goals must be considered; it does not make sense to embed the documentation of multiple complex functions within the kernel-doc header of the top level function as, doing so, would make it harder to review the code changes against the documented specifications and/or to extend the specifications to new functionalities being added.
+
+The end goal is to build a hierarchical, scalable, maintainable documentation.
+
+**Feasibility considerations**: Only the “meaningful” and “useful” expected behavior, and the design elements impacting it, shall be considered (e.g. a printk() logging some info may be omitted). There are two reasons behind this point:
+
+1. Specifying the expected behaviour of the code should be done, in principle, in a code agnostic way. So it is not about writing a pseudo-code redundant implementation, but rather about defining and documenting the developer intent and the integrator’s expectations.
+2. When the expected behavior is defined before implementing the code, such an activity is done by experts using a level of detail that is more abstract than the code itself and they only refer to aspects that are relevant for the design expectations.
diff --git a/Documentation/doc-guide/index.rst b/Documentation/doc-guide/index.rst
index 24d058faa75c..09e459866442 100644
--- a/Documentation/doc-guide/index.rst
+++ b/Documentation/doc-guide/index.rst
@@ -9,6 +9,7 @@ How to write kernel documentation
 
    sphinx
    kernel-doc
+   code-specifications
    parse-headers
    contributing
    maintainer-profile
-- 
2.48.1


