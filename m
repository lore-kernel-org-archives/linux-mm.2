Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B307CD98FD
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA16E8E0009; Thu, 13 Nov 2025 18:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78698E0002; Thu, 13 Nov 2025 18:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8FA38E0009; Thu, 13 Nov 2025 18:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B43F28E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:09:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48AD0C01A6
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:09:07 +0000 (UTC)
X-FDA: 84107126334.08.B996708
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010046.outbound.protection.outlook.com [52.101.46.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57F7A180009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:09:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LjAVvr9x;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.46.46 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763075344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHP9g3cP08ZAVQZNjLi/nvbxZOEmvRJ8Bn8TcVzvtpY=;
	b=jA6ecC4Vw0EGwp628sTQTbXUX1WiiSjIC3mpw96B/gjTBdVYoCP07TzF/Vy00bU6ije7LC
	lKX6mk8OAwUMRTTS5/xgG91Hth6eWckxH5VUk0hQ8dBtYcnVWvKkFHJEaJma93eY3pk+Yj
	YNboiFezpoYCd9WdoboMkedNwbBgb6Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763075344; a=rsa-sha256;
	cv=pass;
	b=AgRB2HvBKti2aoqGQfTHlbTs1czyKBoIzCgJIrhOSGJ8iP0B0SjOLlKkzLEfvT8OCKapph
	AUULSuVZ9fo9Omlqw8YVYkvZos57FztI9NUJTGOvzeajfirWtHLx6YBJI/O/NWQVfsvYVm
	9cgzOHXroewFf7hteyOUkWxhbdk1OuA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LjAVvr9x;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.46.46 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTe4qLEYjaTObiVDQFfGYccin3z4c2urgzap3GWkB59cL7vUpKv2YqopTGkHH55tOLsXT/kTCxVOF3kn2SvvjX8ZlFj1mIroEzluXR4wWDh67HXsk5kMaGArGSielIuByVCs1ZdkP9DCM8evjPfqfM9fPwZBmnHy9egNjWKcqdGA2aldAH3gAwMH6E+kDzwDL2qIm+3Pz7sja265gnUEtHNgJgOoyzSL20krWvSSP9qR6i7RPC+5/QZ4yLO6QCmrVwIDawaNY37wf3SG/+6FqD49yyyrVGld5/qBnMtvMMkCr0go5byMjn7I8zLtsdA28LDyDxNKdMJu1MqRJbF2qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHP9g3cP08ZAVQZNjLi/nvbxZOEmvRJ8Bn8TcVzvtpY=;
 b=kr9CpPA4NVIMumVIIzWJRm/kNwew1WUhSSRzzwRcUNgI1p7YXRQ/mZ+evnOLP7Y6dboCNHdMrE31zM6ustabYrIcvvV4MXigPdjL15Exhnpv97gtB9KfbxExW6eapO9s774n2dHgOAUMCKTvKBVIbfSHrrozlHSlAIKukjPrS/Rh52n2gkC2rMILYv/7BbMraq896q/898bmH6eLAcQyGqy6QoPuZR5aCAZumY4S1jw+tVkUPztLmda1BRAMeD++Hj/W1pOb9C+86EbsSp5can+PBmo0oqUUhWsguKGWq0SLCGyeIdTCD7XkeuV7YQFuY/YsMiTykmFLPp1zZ76szg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHP9g3cP08ZAVQZNjLi/nvbxZOEmvRJ8Bn8TcVzvtpY=;
 b=LjAVvr9xeBc7ceFGHBq+gVFqdhuKhqMp/+2VI4s4OJOBIJS6oBdRdLxsQjfuqlAZB1kyBtEmUjYzi+oos8co44UApHolmdyzx3gILlf1ZZt1LIbyTsXv3ebeOcz4uPqQhbe4dHxbVGzC9zGkWMnnA2Zf+guKKvJ6i8mJzQUINDI=
Received: from BYAPR06CA0007.namprd06.prod.outlook.com (2603:10b6:a03:d4::20)
 by DS0PR12MB9347.namprd12.prod.outlook.com (2603:10b6:8:193::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 23:09:00 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::1c) by BYAPR06CA0007.outlook.office365.com
 (2603:10b6:a03:d4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 23:09:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 23:08:59 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 13 Nov
 2025 15:08:58 -0800
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH 2/3] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
Date: Thu, 13 Nov 2025 17:07:58 -0600
Message-ID: <20251113230759.1562024-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251113230759.1562024-1-michael.roth@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|DS0PR12MB9347:EE_
X-MS-Office365-Filtering-Correlation-Id: c6916acf-51e8-4c67-df8b-08de2309a123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8XEttNk32DGcIMz+HAVwgKa5M4HGaX+fA3s/7Txe0rhb5MMRS7pfRmnkhTcy?=
 =?us-ascii?Q?eOWzVZfWW+jfELmRcDzhhSxUuy/kfqdUTbBL6GkqS1qJPJXyGaelumtUyu2G?=
 =?us-ascii?Q?YX24Qqy9Gj0Syu4ffZymM+fbHo1urvDhkhrgrz6KHrKMCQLreWDPdnv+oXBM?=
 =?us-ascii?Q?X5VAUPmaS3XbpVsGflGbJqVP6MsXus8IZJtVh4fiQKyjEoK/Y+SUqL8MXgz+?=
 =?us-ascii?Q?/r/eW0P49oyDWm+BlDGPvDIMuLXkAeJVqfMoZtxwIpjNzMauJbuxdSFgiHp/?=
 =?us-ascii?Q?tjXpQaq69uW/CDKeIDHo9slwwE61MQEjhIK7OQbNYUnTNCT0AjIpHbB83iAp?=
 =?us-ascii?Q?1qMEGAvWRLvZroW+Drco9dsyKQ4m/kjySPW/NFbvFZUraMX4fLR1beF7LQiY?=
 =?us-ascii?Q?mvkR5nJejsbuY+D+YVSW9W/2QkB/anbORTZPzYaaLFO2rG9xIGbM8wkQShcy?=
 =?us-ascii?Q?skIFT8cKlbguWyI28+3OZ498DDzXp1f1S+qE80PIzWtqVs0ne9k2mwkLLQ2r?=
 =?us-ascii?Q?8HTaIR4GXuhi1Zze80GBO+0lrB89q/mn+rienAt8b/KbYpNMajYal7WDDiZf?=
 =?us-ascii?Q?6fnboTVmfgutZtFG8gBvDmtmTVb6KBnV8daYEvL3cIGThP3gYUa3BZMPhZSs?=
 =?us-ascii?Q?ksSzaY0ehcoXg4hzJtaOeXFkJ82+Yt7Cy/D/GEzGKF3ILy/8IVwkZrbmUecG?=
 =?us-ascii?Q?sZD0/ASJDPdSHrgyzJW4/CSlmjNe2BzR2jqkBOU5Pmg1fNBwMiUWgvNdI6t3?=
 =?us-ascii?Q?6HvR+wiaPSeKlDj1AtlsGrXAu2zpeQvPPA7xNvU17hi422aLYNvYrK+XSQSt?=
 =?us-ascii?Q?LW6fSK7VkJxfgnvD+IaPq8FpQ0aLf8H+tj5IByugn5SUT8kvpuhUdID2t/UX?=
 =?us-ascii?Q?BXyjXV8Ret7Le69QPBopHRDUDVXdOoqOutxZSKjQJdzplEGcetJ/MNMq2Kgk?=
 =?us-ascii?Q?FPmsPvZsdEiy9BEDlQBFWYs1a30/CdN6orFux0YElMI08NcJOrXi3IKiIKhf?=
 =?us-ascii?Q?yZYDwQMBfjjkA9d/5qG1jvEkgxv/WgYdApEoBjLMZyil0ESy8pKEbINA2L9h?=
 =?us-ascii?Q?ddNlm1euKGhtVPiuPgZ6vRtxwqPN8OTlei6r/BCjR4DaPF3Xd95fnEOieCPt?=
 =?us-ascii?Q?TUxjTg5sVUARTKXcH4bTRn4ngvRS9vSWtFAbiDrrQS22ehvA1yTMARsRE+DX?=
 =?us-ascii?Q?z2y2NKs3Rt9NkN7FpBdQDfHLont3vX6D57l+hrREiQQBiAeyDBQeH7F8iaar?=
 =?us-ascii?Q?EswaoUF1NVUNVAr680H44w1W7oH6cI7HL7TCi4bhWXK9w1jv7Evopgopz1iN?=
 =?us-ascii?Q?1m/YSzaUBZewyOpM9ul3QcICPBpw0UyQZGKHKzqy/s7XwI7oXTfutxS1Vr28?=
 =?us-ascii?Q?5+OHq90189QUaCY4s83t2cuHbGXI5qzbTJw0/EfGNDvLuUtrLt9vfrpCv4hj?=
 =?us-ascii?Q?lVkf74XwMMsSiu6wKHa3+KxxnxHqo1kdafOT6R8v/LWsIQcqr1sr13CXgTRn?=
 =?us-ascii?Q?9wk2U9vltxKwhPsklvywBZ7V8lTCiGmz2AJcaDwGNWO1ufjQ1VRZ3xMw/jUM?=
 =?us-ascii?Q?foqp16ooGIGh8bPKxfA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:08:59.7004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6916acf-51e8-4c67-df8b-08de2309a123
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9347
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 57F7A180009
X-Stat-Signature: pona1bztz4mpgfxwaosp5t1qybmugmcq
X-HE-Tag: 1763075344-467405
X-HE-Meta: U2FsdGVkX1+jSbrbNnTbHY0o3eYPOO39lNgq7dfZSmR8wb+o8ykzc/gK1dSwHbSuy0XfC5v8BokPomKqGzDgCon0gHmCbOhZVCKXSTp18MRt0Cgx65fZMEGHbfHRqp6fw5Qq57fAW93BZHLP30VkDmx9cdcq23PFI4642Bla+qxW4RvxEEHYZy1CN9bOBoZQ2q04wSZXm0mHjYThttGETFJsavdYEtULV4t16FkKRdZVaX0NHulqZEdgKTMnmRmtjufCc6+C/lC5RJmQlrTpJZekds6OEFhkeCXaE90Rbl9HPGb5Fbl5YY6VJesVt0WP8qulAy9n+TBpDdLC++cmQHTrwpt+/vEQ47iiw0dkHrrZOYBVk2QGRpF4h1YKAnFbMEV34mgxxdDEva7GN6CPB0nifhWKSrSBTElQlaRMQyMjqa5wxrtxqw0zVY63V3R/EqMFXfgk6XeMNtEUtYnCG6qQ8V/zQOOODeQ19BTNlOH4g4EHhMW7Y8FSmHoi6SLO/3lRNQo3niKHz1N7nOqxyZgp6agyWVKOoDTSDjX3kT6/CreqUaD1zR2b9+sdGwP4wqxfGLBZPZNODGi+QffSs65TmzoLNre916lTG1F2LHpfglEdH9xzTCOlkJt7FGO9sJcXLIz1dEJOq3hYFK0h5Y2s0KNBYXP3JNfJT9TEFLW8M9cQ+rayr/hNpRfg45+CZV9OQ8vyQSHBz1DOHrXQUd4s/GEbOzsH39GI8zUe0Rgq3R4lGlIYUOqNibIuixl44ETdCtgX/vHhR5jXb8iMCab5CHK5aOM8UBUd9C/GBbD7twV04ueU3i02PMZuWM6zEt4A2eeB7ekXq6SR3PxEOCy4g3Ifp0PWu2JwJozCG551ByYIC4dAcF3TZUKaqG+VQjV3vl+aAz6R8Zb+O5BfzeGIutpNAX9N1dwJLCVVOJbhp7x5dPO2RwYtSCJXGyJjXgZiVYYlpNwyXUVHU+y
 Pj9sAWca
 GWN31jyq1DxEDaxY7OjIvxoGoAnnuPN4iNKqvTu2osifEI1nvgPOqQCXmaQRXLD0ucHcXyYOxn1lPksz9zemcgQoMNrPcEeFZesVsGmTfAJOrfxbBEeDtwWAYpUBG7yp6nD5vvqAw5yaeKJF6l8BMBFfVqhFf/4Ifyodo7PdraWkKSxzpENcLPqigi/Xd71hU2kDvpqyy9scUODJitVxjmmoFr43KPh8PfzsxuV9HwXvulx2GaLTMuhh40TKvpBAWNSiWQ16lG2Fw9G1wiTkGFXmm+CiXefM/2OvUb/TC2RxBaU+LnZ7rLL7Tu60bRs/tHNGA4U8wyq5wUNKL4cX1ZSMUf7hwocUI1tLHCB/AjSRh6gdQhME2f8UQQvVmN8bKHi3pyDuOkQneA8+vN+N432oy8aNV6OmV9lDmpcWJW1OTDBjrAsO+MBF4KVAmJTweHxrgMAhSO+Y8Sy2yNckKfGLcv7/lFHQRVyxiywWYpf+9DE03NHGYfi+7HOgUhAs/wV5CvE1ZPultWB9IDcyQLmJ9jF+8mLighXQxkN04IqKC7dg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
go ahead and document this as a requirement, and add a KVM_BUG_ON() in
the post-populate callback handler to ensure future reworks to
guest_memfd do not violate this constraint.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
 arch/x86/kvm/vmx/tdx.c                   | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 5efac62c92c7..6a222e9d0954 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
 :Returns: 0 on success, <0 on error
 
 Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
-provided data from @source_addr.
+provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
 
 Note, before calling this sub command, memory attribute of the range
 [gpa, gpa + nr_pages] needs to be private.  Userspace can use
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3cf80babc3c1..57ed101a1181 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3127,6 +3127,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
+	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
+		return -EINVAL;
+
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
 	 * source page has been swapped out or unmapped in primary memory.
-- 
2.25.1


