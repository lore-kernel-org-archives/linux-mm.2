Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EC4F9D0FB
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 00:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C266B0088; Tue, 14 Apr 2026 20:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3836B0089; Tue, 14 Apr 2026 20:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2A46B0092; Tue, 14 Apr 2026 20:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5076B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:15:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBD0213A5E8
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:15:41 +0000 (UTC)
X-FDA: 84658871682.25.16A6214
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A1AE40002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:15:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WA/+PjIz";
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776212140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X75Z8jcIm7WVjsDYz+mTEljAfNH1stn3Xmye0egk8hM=;
	b=ozgDxI+XiF+xAcWt4yu2a3Fe64W59Wv0eqN6vUv8ZUzAAlr2BI7jS4uoXU1hhTu8ornWJJ
	5IEXHr0omWAYPCr/wBaFv6xfqMBxrDbkLhdp+LFyVYiNWVS2r2aQLJfEnaiE0L4KYpp1bM
	rTEuny6yn862i66D6moyLqsFVKGfL8w=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="WA/+PjIz";
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776212140; a=rsa-sha256;
	cv=pass;
	b=SAm+pbctHeZW/m8oj6dNfEzAciU0sEliRy43CvKVD08Z+KcVjBLcblEYdtAIADta1vI77E
	s2qvs2JAC2+dhGgV+KSBD2NTMK9bOJMrDGKXQ5mVFZhE00W0DEceU2EyZaEgVPCx5CzI+n
	zL0H+DrPFv75PUP4+uwgDO8Gn5M/ktk=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-671c4d08dc2so1596324a12.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776212138; cv=none;
        d=google.com; s=arc-20240605;
        b=DajqIuByLn6tdloYErYQhWz3dCy7ZLbV5QtFzKV4Yd+y4tgXwN0ExI5kcpdKPBaa7S
         ceRfo+I6kBAEhGA1ZsszkzztICyQfNy3f1hdw6/U1FKqSwVNXyacsiJdwv+Ov9+FJg8k
         571e71lavORBFqAMNV5M9514ai0KT566vMGtcrtLdypG4fO4oWkHXxY0ae9UsAOLRJKg
         hCcp256kAA6G+3A+p4Ywib47QtR7xYsZ8Qis7Ak08EJwBqecpBvgczuf4ybZlP/X0I3R
         /XPOA+lXtc4RHoUwGUoVHrZlHNs7Kk79+u21kTrSRF+D5qORUrhKFknZ3gCfBmjKPPR3
         FsRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X75Z8jcIm7WVjsDYz+mTEljAfNH1stn3Xmye0egk8hM=;
        fh=SKgSDAzZWnRtgJw0coCXxyLw7pvG8D7Y3Qu1urmZTAc=;
        b=BshW39PA8aviSWwvWdCG/9V92tDCkimgqCYVw4eK+p6MDjNwaCK54nlGGc0vB56Nj7
         azcsfgs0f73oGmtxqgT6rUbr0vmqhPfkFzAFW7Is9tAJSMn4WrAmamAsprRcc7njCWy2
         6tm2bTRPZ+dpUCQAXl4Mwdu5pF5RGAnU2320uEpg4/I66+VoeeqYHMwNGAu5BfDENUn2
         xyYhYrZfoU+YvvqtHKbCLUXdUuwCcKQ/sCObdsDz61RsU7KzqVc0qi7MybjOa4MgW5iz
         ckBzHSMtz//Ygz09gcatgs4hJlq+px3t3VtRl+4RPt1u7HbvHk/saJkKqM/eefn1w6yf
         dDfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776212138; x=1776816938; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X75Z8jcIm7WVjsDYz+mTEljAfNH1stn3Xmye0egk8hM=;
        b=WA/+PjIzquIwpUCUmRmblQ5+3zwGAoxKy+BmECsZmxnuExmGQ4pYLcB7CDh6mxLi9M
         j4rSZglI2FiPc3ecZJwhhWgq6d3ajpsGwDy4JYmDiQBxULV8retfWmgsbdrwS3Ae25dT
         gm7nbe2CR2f9/VAkC80qc4atH93Bun3iqnZj6XEIbvQ4Psqyt+qbDb0rHmIbO+d2QX1N
         lDr1tI3NI7vX/udpLmHiG3A7AEew2o16AW4j/zjZ83KaRbX42zBpErSZ8gvj8Qyp8VHP
         ZVoFpwYyEphN8o4SWJl/WANE/emWciBFXXpB757ehdc/b6DrjCZ47JCWPmmp9K+NMHxw
         zcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776212138; x=1776816938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X75Z8jcIm7WVjsDYz+mTEljAfNH1stn3Xmye0egk8hM=;
        b=HPOZm7NKbWyO8oVsoAjjcs+cZYGxdY1LjSgKcYujS2LoFIzOLQmnP0VV0W0pFZZtsI
         8AXNScwar9a+l4aIfc122zsk+6jeM/gMzWnKJ1VNTvJPOGISmRBZmK+4PtUphQGBVK2J
         8zK9RiEHGlUEQYQ9TvM70NzhIAKSGC9MST0w2yAX0fHb5nJOZloX/USnXpUvIYrNGpv5
         WF5C0lCphPOhGo53oDbzIN/C9fKu1cuL/cUZDHsEriFX3voLLdXpZIHTzWNNG6TL2iWs
         PAg08F+BNpZWjnvHwFZKZisrPJIVVKsyVXkBTb2lrtPjZY/TgknEUnjvzOJFf3WBeyq3
         vUoA==
X-Forwarded-Encrypted: i=1; AFNElJ+3YEGJ06R4Eh+vj2O6RenIiC8UiWJpOY2xgITAus2Ey3yXjZNnKf+2JGQ9Q7Ytqm2phvA26HY5CA==@kvack.org
X-Gm-Message-State: AOJu0Yw7fAtDjzPLiaNDNqEAHDNmYuDEUk8dmSPUdnkM9CZNbZERY/22
	RJNau1ZkldCkiDP9/CmKMlaqrs1An09f4ZOuqHZkps3QWNEWBqLV5zRqDgBDaZxAU55x+PwVTzM
	wkv+MgMeVdcYIes+JNhBvHP4DAgz2UuFFgSgQTD1pRA==
X-Gm-Gg: AeBDieutk+SR5SmJva7TVphqDnkgAKYF+JEt0iHoZZygjSKXZIWmfjhn7CME9nzFHWo
	2hXWnZg0eWsmoVFnJzzPCqQJ6ItFuq4pfyJhf+8vP/BiAzi73LqEcn9/46xnJNys52GJNMvsHVo
	qIXscq7d4hYF/xNTiWgeQMfs8QYoMQRec5f9WF4orf9VZt4wDL6A1MqvZczOdeutiEPfOBiE/Yb
	5wsM/09y0fhuCUF5YKAadEpvH0z+ZTFpY/EcbrNz5rDMkBoQn+5FQ2Vm/wp95GPLUmsWqwq/+W8
	CDuiYOlTPsx6h/4EPQlmaiQ1qfsl5yV2eG7Nsg==
X-Received: by 2002:a05:6402:35ca:b0:670:a244:6ee9 with SMTP id
 4fb4d7f45d1cf-670a2446f7cmr10318864a12.14.1776212137632; Tue, 14 Apr 2026
 17:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-2-pasha.tatashin@soleen.com> <4bd21077-8711-4ae7-a695-8bc88ce652d1@linux.dev>
In-Reply-To: <4bd21077-8711-4ae7-a695-8bc88ce652d1@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 14 Apr 2026 20:14:59 -0400
X-Gm-Features: AQROBzCqSdJAuuwFhMpg63uCqaqFdKnCS6dn7LU4ts91W7LOTb_CczDFycGjSW8
Message-ID: <CA+CK2bDvFQUYCsD+jKBWw1KfRNJ4DOopAu29iq7SWYrPWV+dzQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] liveupdate: Remove limit on the number of sessions
To: "yanjun.zhu" <yanjun.zhu@linux.dev>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
	skhawaja@google.com, graf@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A1AE40002
X-Stat-Signature: k7jkruisyogoc7j6pk79wou5zqjniqxe
X-Rspam-User: 
X-HE-Tag: 1776212139-153385
X-HE-Meta: U2FsdGVkX18JHsA+kcENSszhPVkm8oUfCkMXgeiegGdPMPT3Ll1/dH9Y8qDMmrpqXdtZEwrJdGUEvysOSeTOR7iOR/TnRH3JBi7qYtjjTOyneALt/4fXeaeYd8lxy7LSR+rMz2qBwYPfE2fNgHttxDM6rXTbr074pJ+TH+d/5Gf/ZD5kqQQ1hIoS+rE3idsso14fevN739SGAl3V4gihYakggO4ObMMYRFKppJFjZilzJkXF41EHqdQ2RqrVMijpTgofdUvqPbNcDaa2dZ4jUg7l+WGssEbtBQ6rCxvkijsCqJSFdeztRStuFtveGhXJZltL4yvaXAicPcu5S3ov+vLPXbXqKbseoiDq5l96zAk5OfOkMgkVR8olpKeuhrRj1RgpviokXjbKhdYzDuodERHVtJDaQlyoF5OooFnClUxuclY1w6f3Luj4SHSk2GhskvXDEpOdyhBXXZx6IV0hkStrqmNfFoN8MzDvmRaCNIY2eKsl0NHBoIt0B0K6idb/lIcFST7gLLEGRZEpkonXhvsw6cq0+sCqXBEMeVDOVCkFQShreSPWztZ1XDupn0GS9tdHniSFNOaNnAeTsMQBRtHbFl9xOEKiacZbFjwEjrHWzwkGSkQyrYni6JlVQbxTG/SLbT1IIRzphxauBr0kzjTAThD4oJc9ZQAxxRMTfvP2ZxIWaX/2+ZfHys+o7RWnYdj1seVS4m10PQpJ1Zyl8a1vwFb6UOSWgqM1Kew7RGOIrQsqL8ap7EdF8NIuDspW4ghDuwXaCsF9ANwVSZCtRAMTh3VTB6tjOIRpHUjat6rcGo2lrRgl/Ie+lalt1CIWnH2AqSKZjFzp+g95sGgNGQUtfiCRW+agR/DRD0KFLhK7nQFxUt2HnFCit0r+XzT2IQ0Q1sZXRc7JqnUQfCd9CGaOLRhqk3E9F+Jd70Xy7FVc/Bl8VrANeJNmxKpz//PF5ZsodG5Ageh1zIlvoNe
 cYfpWNVn
 SeP615fkmMu+LvVGQFLJFOqDgFrlxXaNX/zvVO0MPEb3pr4XpUQQsSMGL71kDEiZMw4MRSRsHBggB3VVw6k+hPJJ4l1RaWtfRbUddETm8PSJoWqeYx5TB9vqB3bUv+WkvaocUI2Ih+45J51JJgqgifPJIJ3Sg1Zqs0suPcgr9ug2f5Y+bdiIssJcpGs2lsptr3VflvpkSWObc82kGv6Qms7coJRW3lyz1ne+QJ57vSFINgZpOvDOaal0eyRfF6jcy7RM8H8EQZpm8cpbdll9fM8FsboGySp/B5KHK6nbeJu2tybQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 8:06=E2=80=AFPM yanjun.zhu <yanjun.zhu@linux.dev> w=
rote:
>
> On 4/14/26 1:02 PM, Pasha Tatashin wrote:
> > Currently, the number of LUO sessions is limited by a fixed number of
> > pre-allocated pages for serialization (16 pages, allowing for ~819
> > sessions).
> >
> > This limitation is problematic if LUO is used to support things such as
> > systemd file descriptor store, and would be used not just as VM memory
> > but to save other states on the machine.
> >
> > Remove this limit by transitioning to a linked-block approach for
> > session metadata serialization. Instead of a single contiguous block,
> > session metadata is now stored in a chain of 16-page blocks. Each block
> > starts with a header containing the physical address of the next block
> > and the number of session entries in the current block.
> >
> > - Bump session ABI version to v3.
> > - Update struct luo_session_header_ser to include a 'next' pointer.
> > - Implement dynamic block allocation in luo_session_insert().
> > - Update setup, serialization, and deserialization logic to traverse
> >    the block chain.
> > - Remove LUO_SESSION_MAX limit.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >   include/linux/kho/abi/luo.h      |  19 +--
> >   kernel/liveupdate/luo_internal.h |  12 +-
> >   kernel/liveupdate/luo_session.c  | 237 +++++++++++++++++++++++-------=
-
> >   3 files changed, 197 insertions(+), 71 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > index 46750a0ddf88..f5732958545e 100644
> > --- a/include/linux/kho/abi/luo.h
> > +++ b/include/linux/kho/abi/luo.h
> > @@ -57,9 +57,10 @@
> >    *   - compatible: "luo-session-v1"
> >    *     Identifies the session ABI version.
> >    *   - luo-session-header: u64
> > - *     The physical address of a `struct luo_session_header_ser`. This=
 structure
> > - *     is the header for a contiguous block of memory containing an ar=
ray of
> > - *     `struct luo_session_ser`, one for each preserved session.
> > + *     The physical address of the first `struct luo_session_header_se=
r`.
> > + *     This structure is the header for a block of memory containing a=
n array
> > + *     of `struct luo_session_ser` entries. Multiple blocks are linked=
 via
> > + *     the `next` field in the header.
> >    *
> >    * File-Lifecycle-Bound Node (luo-flb):
> >    *   This node describes all preserved global objects whose lifecycle=
 is bound
> > @@ -77,9 +78,9 @@
> >    *   `__packed` structures. These structures contain the actual prese=
rved state.
> >    *
> >    *   - struct luo_session_header_ser:
> > - *     Header for the session array. Contains the total page count of =
the
> > - *     preserved memory block and the number of `struct luo_session_se=
r`
> > - *     entries that follow.
> > + *     Header for the session data block. Contains the physical addres=
s of the
> > + *     next session data block and the number of `struct luo_session_s=
er`
> > + *     entries that follow this header in the current block.
> >    *
> >    *   - struct luo_session_ser:
> >    *     Metadata for a single session, including its name and a physic=
al pointer
> > @@ -153,21 +154,23 @@ struct luo_file_set_ser {
> >    *                          luo_session_header_ser
> >    */
> >   #define LUO_FDT_SESSION_NODE_NAME   "luo-session"
> > -#define LUO_FDT_SESSION_COMPATIBLE   "luo-session-v2"
> > +#define LUO_FDT_SESSION_COMPATIBLE   "luo-session-v3"
> >   #define LUO_FDT_SESSION_HEADER              "luo-session-header"
> >
> >   /**
> >    * struct luo_session_header_ser - Header for the serialized session =
data block.
> > + * @next:  Physical address of the next struct luo_session_header_ser.
> >    * @count: The number of `struct luo_session_ser` entries that immedi=
ately
> >    *         follow this header in the memory block.
> >    *
> > - * This structure is located at the beginning of a contiguous block of
> > + * This structure is located at the beginning of a block of
> >    * physical memory preserved across the kexec. It provides the necess=
ary
> >    * metadata to interpret the array of session entries that follow.
> >    *
> >    * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must b=
e updated.
> >    */
> >   struct luo_session_header_ser {
> > +     u64 next;
> >       u64 count;
> >   } __packed;
> >
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_i=
nternal.h
> > index 875844d7a41d..a73f42069301 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -11,6 +11,16 @@
> >   #include <linux/liveupdate.h>
> >   #include <linux/uaccess.h>
> >
> > +/*
> > + * Safeguard limit for the number of serialization blocks. This is use=
d to
> > + * prevent infinite loops and excessive memory allocation in case of m=
emory
> > + * corruption in the preserved state.
> > + *
> > + * This limit allows for ~8.1 million sessions and ~1.2 million files =
per
> > + * session, which is more than enough for all realistic use cases.
> > + */
> > +#define LUO_MAX_BLOCKS 10000
> > +
> >   struct luo_ucmd {
> >       void __user *ubuffer;
> >       u32 user_size;
> > @@ -59,7 +69,6 @@ struct luo_file_set {
> >    * struct luo_session - Represents an active or incoming Live Update =
session.
> >    * @name:       A unique name for this session, used for identificati=
on and
> >    *              retrieval.
> > - * @ser:        Pointer to the serialized data for this session.
> >    * @list:       A list_head member used to link this session into a g=
lobal list
> >    *              of either outgoing (to be preserved) or incoming (res=
tored from
> >    *              previous kernel) sessions.
> > @@ -70,7 +79,6 @@ struct luo_file_set {
> >    */
> >   struct luo_session {
> >       char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> > -     struct luo_session_ser *ser;
> >       struct list_head list;
> >       bool retrieved;
> >       struct luo_file_set file_set;
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_se=
ssion.c
> > index 92b1af791889..007ca34eba79 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -69,30 +69,39 @@
> >   #include <uapi/linux/liveupdate.h>
> >   #include "luo_internal.h"
> >
> > -/* 16 4K pages, give space for 744 sessions */
> > +/* 16 4K pages, give space for 819 sessions per block */
> >   #define LUO_SESSION_PGCNT   16ul
> > -#define LUO_SESSION_MAX              (((LUO_SESSION_PGCNT << PAGE_SHIF=
T) -   \
> > +#define LUO_SESSION_BLOCK_MAX                (((LUO_SESSION_PGCNT << P=
AGE_SHIFT) -   \
> >               sizeof(struct luo_session_header_ser)) /                \
> >               sizeof(struct luo_session_ser))
> >
> > +/**
> > + * struct luo_session_block - Internal representation of a session ser=
ialization block.
> > + * @list: List head for linking blocks in memory.
> > + * @ser:  Pointer to the serialized header in preserved memory.
> > + */
> > +struct luo_session_block {
> > +     struct list_head list;
> > +     struct luo_session_header_ser *ser;
> > +};
> > +
> >   /**
> >    * struct luo_session_header - Header struct for managing LUO session=
s.
> >    * @count:      The number of sessions currently tracked in the @list=
.
> > + * @nblocks:    The number of allocated serialization blocks.
> >    * @list:       The head of the linked list of `struct luo_session` i=
nstances.
> >    * @rwsem:      A read-write semaphore providing synchronized access =
to the
> >    *              session list and other fields in this structure.
> > - * @header_ser: The header data of serialization array.
> > - * @ser:        The serialized session data (an array of
> > - *              `struct luo_session_ser`).
> > + * @blocks:     The list of serialization blocks (struct luo_session_b=
lock).
> >    * @active:     Set to true when first initialized. If previous kerne=
l did not
> >    *              send session data, active stays false for incoming.
> >    */
> >   struct luo_session_header {
> >       long count;
> > +     long nblocks;
> >       struct list_head list;
> >       struct rw_semaphore rwsem;
> > -     struct luo_session_header_ser *header_ser;
> > -     struct luo_session_ser *ser;
> > +     struct list_head blocks;
> >       bool active;
> >   };
> >
> > @@ -110,10 +119,12 @@ static struct luo_session_global luo_session_glob=
al =3D {
> >       .incoming =3D {
> >               .list =3D LIST_HEAD_INIT(luo_session_global.incoming.list=
),
> >               .rwsem =3D __RWSEM_INITIALIZER(luo_session_global.incomin=
g.rwsem),
> > +             .blocks =3D LIST_HEAD_INIT(luo_session_global.incoming.bl=
ocks),
> >       },
> >       .outgoing =3D {
> >               .list =3D LIST_HEAD_INIT(luo_session_global.outgoing.list=
),
> >               .rwsem =3D __RWSEM_INITIALIZER(luo_session_global.outgoin=
g.rwsem),
> > +             .blocks =3D LIST_HEAD_INIT(luo_session_global.outgoing.bl=
ocks),
> >       },
> >   };
> >
> > @@ -140,6 +151,70 @@ static void luo_session_free(struct luo_session *s=
ession)
> >       kfree(session);
> >   }
> >
> > +static int luo_session_add_block(struct luo_session_header *sh,
> > +                              struct luo_session_header_ser *ser)
> > +{
> > +     struct luo_session_block *block;
> > +
> > +     if (sh->nblocks >=3D LUO_MAX_BLOCKS)
> > +             return -ENOSPC;
> > +
> > +     block =3D kzalloc_obj(*block);
> > +     if (!block)
> > +             return -ENOMEM;
> > +
> > +     block->ser =3D ser;
> > +     list_add_tail(&block->list, &sh->blocks);
> > +     sh->nblocks++;
> > +
> > +     return 0;
> > +}
> > +
> > +static int luo_session_create_ser_block(struct luo_session_header *sh)
> > +{
> > +     struct luo_session_block *last =3D NULL;
> > +     struct luo_session_header_ser *ser;
> > +     int err;
> > +
> > +     ser =3D kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
> > +     if (IS_ERR(ser))
> > +             return PTR_ERR(ser);
> > +
> > +     if (!list_empty(&sh->blocks))
> > +             last =3D list_last_entry(&sh->blocks, struct luo_session_=
block, list);
> > +
> > +     err =3D luo_session_add_block(sh, ser);
> > +     if (err)
> > +             goto err_unpreserve;
> > +
> > +     if (last)
> > +             last->ser->next =3D virt_to_phys(ser);
> > +
> > +     return 0;
> > +
> > +err_unpreserve:
> > +     kho_unpreserve_free(ser);
> > +     return err;
> > +}
> > +
> > +static void luo_session_destroy_ser_blocks(struct luo_session_header *=
sh,
> > +                                        bool unpreserve)
> > +{
> > +     struct luo_session_block *block, *tmp;
> > +
> > +     list_for_each_entry_safe(block, tmp, &sh->blocks, list) {
> > +             if (block->ser) {
> > +                     if (unpreserve)
> > +                             kho_unpreserve_free(block->ser);
> > +                     else
> > +                             kho_restore_free(block->ser);
> > +             }
> > +             list_del(&block->list);
> > +             kfree(block);
> > +             sh->nblocks--;
> > +     }
> > +}
> > +
> >   static int luo_session_insert(struct luo_session_header *sh,
> >                             struct luo_session *session)
> >   {
> > @@ -147,15 +222,6 @@ static int luo_session_insert(struct luo_session_h=
eader *sh,
> >
> >       guard(rwsem_write)(&sh->rwsem);
> >
> > -     /*
> > -      * For outgoing we should make sure there is room in serializatio=
n array
> > -      * for new session.
> > -      */
> > -     if (sh =3D=3D &luo_session_global.outgoing) {
> > -             if (sh->count =3D=3D LUO_SESSION_MAX)
> > -                     return -ENOMEM;
> > -     }
> > -
> >       /*
> >        * For small number of sessions this loop won't hurt performance
> >        * but if we ever start using a lot of sessions, this might
> > @@ -166,6 +232,20 @@ static int luo_session_insert(struct luo_session_h=
eader *sh,
> >               if (!strncmp(it->name, session->name, sizeof(it->name)))
> >                       return -EEXIST;
> >       }
> > +
> > +     /*
> > +      * For outgoing we should make sure there is room in serializatio=
n array
> > +      * for new session. If not, allocate a new block.
> > +      */
> > +     if (sh =3D=3D &luo_session_global.outgoing) {
> > +             if (sh->count =3D=3D sh->nblocks * LUO_SESSION_BLOCK_MAX)=
 {
>
> I am not sure if "LUO_SESSION_BLOCK_MAX 10000" has special meaning or not=
.

LUO_SESSION_BLOCK_MAX is calculated based on the number of times
"struct luo_session_ser)" fits into a page-aligned block minus the
luo_session_header_ser. It is not power-of-two, so there is no pretty
way to change this to avoid multiplcation.

>
> If not, we can use the following:
>
> #define LUO_SESSION_BLOCK_SHIFT 13
> #define LUO_SESSION_BLOCK_MAX   (1UL << LUO_SESSION_BLOCK_SHIFT) // 8192
> #define LUO_SESSION_BLOCK_MASK  (LUO_SESSION_BLOCK_MAX - 1)      // 0x1FF=
F
>
> if (!(sh->count & LUO_SESSION_BLOCK_MASK) && sh->count > 0) {
> ...
> }
>
> Zhu Yanjun
>
> > +                     int err =3D luo_session_create_ser_block(sh);
> > +
> > +                     if (err)
> > +                             return err;
> > +             }
> > +     }
> > +
> >       list_add_tail(&session->list, &sh->list);
> >       sh->count++;
> >
> > @@ -444,9 +524,12 @@ int __init luo_session_setup_outgoing(void *fdt_ou=
t)
> >       u64 header_ser_pa;
> >       int err;
> >
> > -     header_ser =3D kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT=
);
> > -     if (IS_ERR(header_ser))
> > -             return PTR_ERR(header_ser);
> > +     err =3D luo_session_create_ser_block(&luo_session_global.outgoing=
);
> > +     if (err)
> > +             return err;
> > +
> > +     header_ser =3D list_first_entry(&luo_session_global.outgoing.bloc=
ks,
> > +                                   struct luo_session_block, list)->se=
r;
> >       header_ser_pa =3D virt_to_phys(header_ser);
> >
> >       err =3D fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
> > @@ -459,19 +542,18 @@ int __init luo_session_setup_outgoing(void *fdt_o=
ut)
> >       if (err)
> >               goto err_unpreserve;
> >
> > -     luo_session_global.outgoing.header_ser =3D header_ser;
> > -     luo_session_global.outgoing.ser =3D (void *)(header_ser + 1);
> >       luo_session_global.outgoing.active =3D true;
> >
> >       return 0;
> >
> >   err_unpreserve:
> > -     kho_unpreserve_free(header_ser);
> > +     luo_session_destroy_ser_blocks(&luo_session_global.outgoing, true=
);
> >       return err;
> >   }
> >
> >   int __init luo_session_setup_incoming(void *fdt_in)
> >   {
> > +     struct luo_session_header *sh =3D &luo_session_global.incoming;
> >       struct luo_session_header_ser *header_ser;
> >       int err, header_size, offset;
> >       u64 header_ser_pa;
> > @@ -501,11 +583,14 @@ int __init luo_session_setup_incoming(void *fdt_i=
n)
> >       }
> >
> >       header_ser_pa =3D get_unaligned((u64 *)ptr);
> > -     header_ser =3D phys_to_virt(header_ser_pa);
> > -
> > -     luo_session_global.incoming.header_ser =3D header_ser;
> > -     luo_session_global.incoming.ser =3D (void *)(header_ser + 1);
> > -     luo_session_global.incoming.active =3D true;
> > +     while (header_ser_pa) {
> > +             header_ser =3D phys_to_virt(header_ser_pa);
> > +             err =3D luo_session_add_block(sh, header_ser);
> > +             if (err)
> > +                     return err;
> > +             header_ser_pa =3D header_ser->next;
> > +     }
> > +     sh->active =3D true;
> >
> >       return 0;
> >   }
> > @@ -513,6 +598,7 @@ int __init luo_session_setup_incoming(void *fdt_in)
> >   int luo_session_deserialize(void)
> >   {
> >       struct luo_session_header *sh =3D &luo_session_global.incoming;
> > +     struct luo_session_block *block;
> >       static bool is_deserialized;
> >       static int err;
> >
> > @@ -539,40 +625,49 @@ int luo_session_deserialize(void)
> >        * userspace to detect the failure and trigger a reboot, which wi=
ll
> >        * reliably reset devices and reclaim memory.
> >        */
> > -     for (int i =3D 0; i < sh->header_ser->count; i++) {
> > -             struct luo_session *session;
> > -
> > -             session =3D luo_session_alloc(sh->ser[i].name);
> > -             if (IS_ERR(session)) {
> > -                     pr_warn("Failed to allocate session [%.*s] during=
 deserialization %pe\n",
> > -                             (int)sizeof(sh->ser[i].name),
> > -                             sh->ser[i].name, session);
> > -                     err =3D PTR_ERR(session);
> > -                     return err;
> > -             }
> > +     list_for_each_entry(block, &sh->blocks, list) {
> > +             struct luo_session_ser *ser =3D (void *)(block->ser + 1);
> >
> > -             err =3D luo_session_insert(sh, session);
> > -             if (err) {
> > -                     pr_warn("Failed to insert session [%s] %pe\n",
> > -                             session->name, ERR_PTR(err));
> > -                     luo_session_free(session);
> > +             if (block->ser->count > LUO_SESSION_BLOCK_MAX) {
> > +                     pr_warn("Session block contains too many entries:=
 %llu\n",
> > +                             block->ser->count);
> > +                     err =3D -EINVAL;
> >                       return err;
> >               }
> >
> > -             scoped_guard(mutex, &session->mutex) {
> > -                     err =3D luo_file_deserialize(&session->file_set,
> > -                                                &sh->ser[i].file_set_s=
er);
> > -             }
> > -             if (err) {
> > -                     pr_warn("Failed to deserialize files for session =
[%s] %pe\n",
> > -                             session->name, ERR_PTR(err));
> > -                     return err;
> > +             for (int i =3D 0; i < block->ser->count; i++) {
> > +                     struct luo_session *session;
> > +
> > +                     session =3D luo_session_alloc(ser[i].name);
> > +                     if (IS_ERR(session)) {
> > +                             pr_warn("Failed to allocate session [%.*s=
] during deserialization %pe\n",
> > +                                     (int)sizeof(ser[i].name),
> > +                                     ser[i].name, session);
> > +                             err =3D PTR_ERR(session);
> > +                             return err;
> > +                     }
> > +
> > +                     err =3D luo_session_insert(sh, session);
> > +                     if (err) {
> > +                             pr_warn("Failed to insert session [%s] %p=
e\n",
> > +                                     session->name, ERR_PTR(err));
> > +                             luo_session_free(session);
> > +                             return err;
> > +                     }
> > +
> > +                     scoped_guard(mutex, &session->mutex) {
> > +                             err =3D luo_file_deserialize(&session->fi=
le_set,
> > +                                                        &ser[i].file_s=
et_ser);
> > +                     }
> > +                     if (err) {
> > +                             pr_warn("Failed to deserialize files for =
session [%s] %pe\n",
> > +                                     session->name, ERR_PTR(err));
> > +                             return err;
> > +                     }
> >               }
> >       }
> >
> > -     kho_restore_free(sh->header_ser);
> > -     sh->header_ser =3D NULL;
> > -     sh->ser =3D NULL;
> > +     luo_session_destroy_ser_blocks(sh, false);
> >
> >       return 0;
> >   }
> > @@ -580,31 +675,51 @@ int luo_session_deserialize(void)
> >   int luo_session_serialize(void)
> >   {
> >       struct luo_session_header *sh =3D &luo_session_global.outgoing;
> > +     struct luo_session_block *block;
> >       struct luo_session *session;
> > +     struct luo_session_ser *ser;
> >       int i =3D 0;
> >       int err;
> >
> >       guard(rwsem_write)(&sh->rwsem);
> > +
> > +     if (list_empty(&sh->blocks))
> > +             return 0;
> > +
> > +     block =3D list_first_entry(&sh->blocks, struct luo_session_block,=
 list);
> > +     ser =3D (void *)(block->ser + 1);
> > +
> >       list_for_each_entry(session, &sh->list, list) {
> > -             err =3D luo_session_freeze_one(session, &sh->ser[i]);
> > +             if (i =3D=3D LUO_SESSION_BLOCK_MAX) {
> > +                     block->ser->count =3D i;
> > +                     block =3D list_next_entry(block, list);
> > +                     ser =3D (void *)(block->ser + 1);
> > +                     i =3D 0;
> > +             }
> > +
> > +             err =3D luo_session_freeze_one(session, &ser[i]);
> >               if (err)
> >                       goto err_undo;
> >
> > -             strscpy(sh->ser[i].name, session->name,
> > -                     sizeof(sh->ser[i].name));
> > +             strscpy(ser[i].name, session->name,
> > +                     sizeof(ser[i].name));
> >               i++;
> >       }
> > -     sh->header_ser->count =3D sh->count;
> > +     block->ser->count =3D i;
> >
> >       return 0;
> >
> >   err_undo:
> >       list_for_each_entry_continue_reverse(session, &sh->list, list) {
> >               i--;
> > -             luo_session_unfreeze_one(session, &sh->ser[i]);
> > -             memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
> > +             if (i < 0) {
> > +                     block =3D list_prev_entry(block, list);
> > +                     ser =3D (void *)(block->ser + 1);
> > +                     i =3D LUO_SESSION_BLOCK_MAX - 1;
> > +             }
> > +             luo_session_unfreeze_one(session, &ser[i]);
> > +             memset(ser[i].name, 0, sizeof(ser[i].name));
> >       }
> >
> >       return err;
> >   }
> > -
>
>

